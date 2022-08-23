defmodule WeatherAppWeb.LocationTempCard do
  use WeatherAppWeb, :live_component

  alias WeatherApp.Api

  def render(assigns) do
    ~H"""
    <dl class="grid sm:block lg:grid xl:block grid-cols-2 grid-rows-2 items-center">
      <div>
        <dt class="sr-only"><%= "#{@stats["name"]}, #{@stats["sys"]["country"]}" %></dt>
        <dd class="font-semibold text-slate-900 group-hover:text-white dark:text-slate-100">
          <%= @stats["name"] %>
        </dd>
      </div>
      <div>
        <dt class="sr-only"><%= @stats["sys"]["country"] %></dt>
        <dd class="group-hover:text-blue-200"><%= @stats["sys"]["country"] %></dd>
      </div>
      <%= for weather <- @stats["weather"] do %>
        <div>
          <dt class="sr-only"><%= weather["description"] %></dt>
          <dd class="group-hover:text-blue-200"><%= weather["description"] %></dd>
        </div>
      <% end %>
      <div>
        <dt class="sr-only"><%= "#{Api.format_temp(@stats["main"]["temp"], @temp_in)} #{@temp_in}" %></dt>
        <dd class="group-hover:text-blue-200"><%= "#{Api.format_temp(@stats["main"]["temp"], @temp_in)} #{@temp_in}"%></dd>
      </div>
    </dl>
    """
  end
end
