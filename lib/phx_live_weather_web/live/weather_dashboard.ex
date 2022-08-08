defmodule WeatherAppWeb.WeatherDashbord do
  use WeatherAppWeb, :live_view

  alias WeatherApp.Api

  def render(assigns) do
    ~H"""
    Weather Dashboard
    <br />
    Location: <%= @stats["name"] %>
    <br />
    Weather: <%= for weather <- @stats["weather"] do %>
      <%= weather["description"] %>
    <% end %>
    <br />
    Temparature: <%= "#{Api.format_temp(@stats["main"]["temp"], @temp_in)} #{@temp_in}" %>
    """
  end

  def mount(_params, session, socket) do
    stats = Api.get_weather(session["current_location"])
    {:ok, socket |> assign(:stats, stats) |> assign(:temp_in, "C")}
  end
end
