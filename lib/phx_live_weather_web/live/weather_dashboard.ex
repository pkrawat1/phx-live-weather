defmodule WeatherAppWeb.WeatherDashboard do
  use WeatherAppWeb, :live_view

  alias WeatherApp.Api
  alias WeatherAppWeb.{LocationSearch, LocationTempCard}

  def render(assigns) do
    ~H"""
    <section class="container m-auto">
      <header class="bg-white space-y-4 p-4 sm:px-8 sm:py-6 lg:p-4 xl:px-8 xl:py-6">
        <div class="flex items-center justify-between">
          <h2 class="font-semibold text-slate-900">Weather Dashboard</h2>
          <a href="/new" class="hover:bg-blue-400 group flex items-center rounded-md bg-blue-500 text-white text-sm font-medium pl-2 pr-3 py-2 shadow-sm">
            <svg width="20" height="20" fill="currentColor" class="mr-2" aria-hidden="true">
              <path d="M10 5a1 1 0 0 1 1 1v3h3a1 1 0 1 1 0 2h-3v3a1 1 0 1 1-2 0v-3H6a1 1 0 1 1 0-2h3V6a1 1 0 0 1 1-1Z" />
            </svg>
            New
          </a>
        </div>
        <.live_component module={LocationSearch} id="location_search" location_list={@location_list} />
      </header>
      <ul class="bg-slate-50 p-4 sm:px-8 sm:pt-6 sm:pb-8 lg:p-4 xl:px-8 xl:pt-6 xl:pb-8 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2 gap-4 text-sm leading-6">
        <li x-for="project in projects">
          <%= for stats <- @stats do %>
            <.live_component module={LocationTempCard} id={stats["name"]} stats={stats} temp_in={@temp_in} />
          <% end %>
        </li>
      </ul>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    stats = Api.get_weather(get_connect_params(socket)["client_data"]["saved_locations"])

    {:ok,
     socket
     |> assign(:stats, stats)
     |> assign(:temp_in, "C")
     |> assign(:location_list, [])
     |> assign(:saved_locations, [])}
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) when query != "" do
    {:noreply, assign(socket, :location_list, Api.location_list(query))}
  end

  def handle_event("search", _, socket), do: {:noreply, assign(socket, :location_list, [])}

  def handle_event("add-location", %{"lat" => lat, "lon" => lon} = location, socket) do
    data_exists =
      Enum.find(
        socket.assigns.saved_locations,
        &(&1["lat"] === lat && &1["lon"] === lon)
      ) || false

    stats =
      if data_exists,
        do: socket.assigns.stats,
        else: [Api.get_weather(location) | socket.assigns.stats]

    saved_locations =
      if data_exists,
        do: socket.assigns.saved_locations,
        else: [location | socket.assigns.saved_locations]

    IO.inspect socket.assigns
    socket =
      socket
      |> assign(:saved_locations, saved_locations)
      |> assign(:stats, stats)
      |> assign(:temp_in, "C")
      |> assign(:location_list, [])

    {:noreply,
     push_event(
       socket,
       "saveData",
       %{saved_locations: saved_locations}
     )}
  end
end
