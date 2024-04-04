defmodule AnalyticsDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AnalyticsDemoWeb.Telemetry,
      # Start the Ecto repository
      AnalyticsDemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AnalyticsDemo.PubSub},
      # Start Finch
      {Finch, name: AnalyticsDemo.Finch},
      # Start the Endpoint (http/https)
      AnalyticsDemoWeb.Endpoint
      # Start a worker by calling: AnalyticsDemo.Worker.start_link(arg)
      # {AnalyticsDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AnalyticsDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AnalyticsDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
