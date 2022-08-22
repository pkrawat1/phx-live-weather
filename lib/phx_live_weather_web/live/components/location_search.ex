defmodule WeatherAppWeb.LocationSearch do
  use WeatherAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.form class="group relative" let={f} for={:search_field} phx-submit="search">
        <svg width="20" height="20" fill="currentColor" class="absolute left-3 top-1/2 -mt-2.5 text-slate-400 pointer-events-none group-focus-within:text-blue-500" aria-hidden="true">
          <path fill-rule="evenodd" clip-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" />
        </svg>
        <%= text_input f, :query, phx_change: "search", phx_debounce: 300, placeholder: "location", class: "focus:ring-2 focus:ring-blue-500 focus:outline-none appearance-none w-full text-sm leading-6 text-slate-900 placeholder-slate-400 rounded-md py-2 pl-10 ring-1 ring-slate-200 shadow-sm" %>
      </.form>
      <%= if length(@location_list) > 0 do %>
        <%= for location <- @location_list do %>
          <%= "#{location["name"]}, #{location["state"]}" %>
          <button class="rounded-full" phx-click="add-location" phx-value-lat={location["lat"]} phx-value-lon={location["lon"]}>
            Select
          </button>
          <br />
        <% end %>
      <% end %>
    </div>
    """
  end
end
