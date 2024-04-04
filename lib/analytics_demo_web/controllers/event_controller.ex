defmodule AnalyticsDemoWeb.EventController do
  use AnalyticsDemoWeb, :controller
  alias AnalyticsDemo.Dashboard
  alias AnalyticsDemo.Dashboard.Event
  action_fallback AnalyticsDemoWeb.FallbackController

  def create(conn, params) do
    with {:ok, %Event{}} <- Dashboard.create_event(params) do
      send_resp(conn, 201, "created")
    end
  end
end
