defmodule AnalyticsDemo.Repo do
  use Ecto.Repo,
    otp_app: :analytics_demo,
    adapter: Ecto.Adapters.Postgres
end
