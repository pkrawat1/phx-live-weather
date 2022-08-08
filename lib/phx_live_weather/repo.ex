defmodule WeatherApp.Repo do
  use Ecto.Repo,
    otp_app: :phx_live_weather,
    adapter: Ecto.Adapters.Postgres
end
