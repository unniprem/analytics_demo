defmodule AnalyticsDemoWeb.EventAnalyticsController do
  use AnalyticsDemoWeb, :controller
  alias AnalyticsDemo.Dashboard
  action_fallback AnalyticsDemoWeb.FallbackController

  def index(conn, params) do
    with {:ok, data} <- Dashboard.list_events_per_date(params) do
      render(conn, :index, data: data)
    end
  end
end
