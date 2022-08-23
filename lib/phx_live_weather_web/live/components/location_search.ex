defmodule WeatherAppWeb.LocationSearch do
  use WeatherAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="w-full  relative">
        <.form class="group relative" let={f} for={:search_field} phx-submit="search">
          <Heroicons.Solid.search class="h-6 w-6 absolute left-3 top-1/2 -mt-3 text-slate-400 pointer-events-none group-focus-within:text-blue-500" />
          <%= text_input f, :query, phx_change: "search", phx_debounce: 300, autocomplete: "off", placeholder: "Search for location", class: "appearance-none w-full text-sm leading-6 bg-transparent text-slate-900 placeholder:text-slate-400 rounded-md py-2 pl-10 ring-1 ring-slate-200 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 dark:text-slate-100 dark:placeholder:text-slate-500 dark:ring-0 dark:focus:ring-2" %>
        </.form>
        <%= if length(@location_list) > 0 do %>
          <div class="absolute w-full bg-white dark:bg-slate-800 -bottom-30 shadow-md">
            <%= for location <- @location_list do %>
              <button class="w-full py-1 pl-10 hover:bg-blue-500 hover:text-blue-200 text-left" phx-click="add-location" phx-value-lat={location["lat"]} phx-value-lon={location["lon"]}>
                <%= "#{location["name"]}, #{location["state"]}" %>
              </button>
              <br />
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
