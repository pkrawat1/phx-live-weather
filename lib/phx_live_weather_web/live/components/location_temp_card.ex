defmodule WeatherAppWeb.LocationTempCard do
  use WeatherAppWeb, :live_component

  alias WeatherApp.Api

  def render(assigns) do
    ~H"""
    <a :href="project.url" class="hover:bg-blue-500 hover:ring-blue-500 hover:shadow-md group rounded-md p-3 bg-white ring-1 ring-slate-200 shadow-sm">
      <dl class="grid sm:block lg:grid xl:block grid-cols-2 grid-rows-2 items-center">
        <div>
          <dt class="sr-only"><%= "#{@stats["name"]}, #{@stats["sys"]["country"]}" %></dt>
          <dd class="group-hover:text-white font-semibold text-slate-900">
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
    </a>
    """
  end
end
