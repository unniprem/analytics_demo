defmodule AnalyticsDemoWeb.UserAnalyticsController do
  use AnalyticsDemoWeb, :controller
  alias AnalyticsDemo.Dashboard

  def index(conn, params) do
    render(conn, :index, data: Dashboard.list_events_by_users(params))
  end
end
