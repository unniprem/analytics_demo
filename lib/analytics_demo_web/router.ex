defmodule AnalyticsDemoWeb.Router do
  use AnalyticsDemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AnalyticsDemoWeb do
    pipe_through :api
    post "/events", EventController, :create
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:analytics_demo, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
