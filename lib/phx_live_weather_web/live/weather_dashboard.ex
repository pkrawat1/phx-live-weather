defmodule WeatherAppWeb.WeatherDashboard do
  use WeatherAppWeb, :live_view

  alias WeatherApp.Api
  alias WeatherAppWeb.{LocationSearch, LocationTempCard}

  def render(assigns) do
    ~H"""
    <section class="container mx-auto relative z-10 rounded-xl bg-white shadow-xl ring-1 ring-slate-900/5 overflow-hidden my-10 xl:mt-18 dark:bg-slate-800">
      <header class="rounded-t-xl space-y-4 p-4 sm:px-8 sm:py-6 lg:p-4 xl:px-8 xl:py-6 dark:highlight-white/10">
        <div class="flex items-center justify-between">
          <h2 class="font-semibold text-slate-900 dark:text-white">Weather Dashboard</h2>
        </div>
        <.live_component module={LocationSearch} id="location_search" location_list={@location_list} />
      </header>
      <ul class="bg-slate-50 p-4 sm:px-8 sm:pt-6 sm:pb-8 lg:p-4 xl:px-8 xl:pt-6 xl:pb-8 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2 gap-4 text-sm leading-6 dark:bg-slate-900/40 dark:ring-1 dark:ring-white/5">
        <%= for stats <- @stats do %>
          <li class="group cursor-pointer rounded-md p-3 bg-white ring-1 ring-slate-200 shadow-sm hover:bg-blue-500 hover:ring-blue-500 hover:shadow-md dark:bg-slate-700 dark:ring-0 dark:highlight-white/10 dark:hover:bg-blue-500" id={stats["name"]}>
            <.live_component module={LocationTempCard} id={stats["name"]} stats={stats} temp_in={@temp_in} />
          </li>
        <% end %>
      </ul>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket),
      do: :timer.send_interval(:timer.minutes(5), self(), :update_weather_data)

    saved_locations = get_connect_params(socket)["client_data"]["saved_locations"] || []
    stats = saved_locations |> Api.get_grouped_weather() |> Map.get("list", [])

    {:ok,
     socket
     |> assign(:stats, stats)
     |> assign(:temp_in, "C")
     |> assign(:location_list, [])
     |> assign(:saved_locations, saved_locations)}
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) when query != "" do
    {:noreply, assign(socket, :location_list, Api.location_list(query))}
  end

  def handle_event("search", _, socket), do: {:noreply, assign(socket, :location_list, [])}

  def handle_event(
        "add-location",
        %{"lat" => lat, "lon" => lon} = location,
        %{assigns: %{saved_locations: saved_locations, stats: stats}} = socket
      ) do
    location_stat = Api.get_weather(location)
    data_exists = location_stat["id"] in saved_locations

    stats = if data_exists, do: stats, else: [Api.get_weather(location) | stats]

    saved_locations =
      if data_exists,
        do: saved_locations,
        else: Enum.map(stats, & &1["id"])

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

  def handle_info(:update_weather_data, %{assigns: %{stats: stats}} = socket) do
    stats =
      stats
      |> Enum.map(& &1["id"])
      |> Api.get_grouped_weather()
      |> Map.get("list", [])

    {:noreply, assign(socket, :stats, stats)}
  end
end
