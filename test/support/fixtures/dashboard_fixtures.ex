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
        "attributes" => %{},
        "user_id" => "some_user_id",
        "event_time" => ~U[2024-04-03 12:38:00Z],
        "event_name" => "some event_name"
      })
      |> AnalyticsDemo.Dashboard.create_event()

    event
  end
end
