defmodule WeatherAppWeb.WeatherDashboard do
  use WeatherAppWeb, :live_view

  alias WeatherApp.Api

  def render(assigns) do
    ~H"""
    Weather Dashboard
    <br />
    <.form let={f} for={:search_field} phx-submit="search">
      <%= text_input f, :query, phx_change: "search", phx_debounce: 300, placeholder: "location", class: "rounded text-pink-500" %>
    </.form>
    <br />
    <%= if length(@location_list) > 0 do %>
      <%= for location <- @location_list do %>
        <%= "#{location["name"]}, #{location["state"]}" %>
        <button class="rounded-full" phx-click="change-location" phx-value-lat={location["lat"]} phx-value-lon={location["lon"]}>
          Select
        </button>
        <br />
      <% end %>
    <% end %>
    <br />
    Location: <%= "#{@stats["name"]}, #{@stats["sys"]["country"]}" %>
    <br />
    Weather: <%= for weather <- @stats["weather"] do %>
      <%= weather["description"] %>
    <% end %>
    <br />
    Temparature: <%= "#{Api.format_temp(@stats["main"]["temp"], @temp_in)} #{@temp_in}" %>
    """
  end

  def mount(_params, _session, socket) do
    stats = Api.get_weather(socket.assigns[:current_location])
    {:ok, socket |> assign(:stats, stats) |> assign(:temp_in, "C") |> assign(:location_list, [])}
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) when query != "" do
    {:noreply, assign(socket, :location_list, Api.location_list(query))}
  end

  def handle_event("search", _, socket), do: {:noreply, assign(socket, :location_list, [])}

  def handle_event("change-location", %{"lat" => _lat, "lon" => _lon} = location, socket) do
    stats = Api.get_weather(location)

    {:noreply,
     socket
     |> assign(:current_location, location)
     |> assign(:stats, stats)
     |> assign(:temp_in, "C")
     |> assign(:location_list, [])}
  end
end
