defmodule AnalyticsDemo.DashboardTest do
  use AnalyticsDemo.DataCase

  alias AnalyticsDemo.Dashboard

  describe "events" do
    alias AnalyticsDemo.Dashboard.Event

    import AnalyticsDemo.DashboardFixtures

    @invalid_attrs %{
      "attributes" => nil,
      "user_id" => nil,
      "event_time" => nil,
      "event_name" => nil
    }

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        "attributes" => %{},
        "user_id" => "some_user_id",
        "event_time" => ~U[2024-04-03 12:38:00Z],
        "event_name" => "some event_name"
      }

      assert {:ok, %Event{} = event} = Dashboard.create_event(valid_attrs)
      assert event.attributes == %{}
      assert event.user_id == "some_user_id"
      assert event.event_time == ~U[2024-04-03 12:38:00Z]
      assert event.event_name == "some event_name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_event(@invalid_attrs)
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_event(event, @invalid_attrs)
      assert event == Dashboard.get_event!(event.id)
    end
  end
end
