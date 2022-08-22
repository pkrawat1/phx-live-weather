defmodule WeatherApp.Api do
  @geo_api "https://api.openweathermap.org/geo/1.0/direct?appid=#{Application.fetch_env!(:phx_live_weather, :appid)}&"
  @weather_api "https://api.openweathermap.org/data/2.5/weather?appid=#{Application.fetch_env!(:phx_live_weather, :appid)}&"
  @location_suggest_limit 5
  @cache_key :weather_cache

  def get_weather(locations) when is_nil(locations), do: []
  def get_weather(locations) when is_list(locations), do: Enum.map(locations, &get_weather(&1))

  def get_weather(%{"lat" => lat, "lon" => lon}) do
    url = @weather_api <> "lat=#{lat}&lon=#{lon}"

    case Cachex.get(@cache_key, url) do
      {:ok, nil} ->
        %HTTPoison.Response{
          body: body
        } = HTTPoison.get!(url)

        weather = Jason.decode!(body)
        Cachex.put(@cache_key, url, weather, ttl: :timer.minutes(10))
        weather

      {:ok, weather} ->
        weather
    end
  end

  def get_weather(_), do: []

  def location_list(location) do
    url = @geo_api <> "q=#{location}&limit=#{@location_suggest_limit}"

    case Cachex.get(@cache_key, url) do
      {:ok, nil} ->
        %HTTPoison.Response{
          body: body
        } = HTTPoison.get!(url)

        location_list = Jason.decode!(body)
        Cachex.put(@cache_key, url, location_list, ttl: :timer.minutes(10))
        location_list

      {:ok, location_list} ->
        location_list
    end
  end

  def format_temp(kelvin_temp, "C"), do: Float.round(kelvin_temp - 273.15, 2)

  def format_temp(kelvin_temp, "F"),
    do: Float.round(format_temp(kelvin_temp, "C") * (9 / 5) + 32, 2)
end
