defmodule AnalyticsDemo.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AnalyticsDemo.Dashboard` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        attributes: %{},
        event_name: "some event_name",
        event_time: ~U[2024-04-03 12:38:00Z],
        user_id: "some user_id"
      })
      |> AnalyticsDemo.Dashboard.create_event()

    event
  end
end
