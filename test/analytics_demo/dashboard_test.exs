defmodule AnalyticsDemo.DashboardTest do
  use AnalyticsDemo.DataCase

  alias AnalyticsDemo.Dashboard

  describe "events" do
    alias AnalyticsDemo.Dashboard.Event

    import AnalyticsDemo.DashboardFixtures

    @invalid_attrs %{attributes: nil, user_id: nil, event_time: nil, event_name: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Dashboard.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Dashboard.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{attributes: %{}, user_id: "some user_id", event_time: ~U[2024-04-03 12:38:00Z], event_name: "some event_name"}

      assert {:ok, %Event{} = event} = Dashboard.create_event(valid_attrs)
      assert event.attributes == %{}
      assert event.user_id == "some user_id"
      assert event.event_time == ~U[2024-04-03 12:38:00Z]
      assert event.event_name == "some event_name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{attributes: %{}, user_id: "some updated user_id", event_time: ~U[2024-04-04 12:38:00Z], event_name: "some updated event_name"}

      assert {:ok, %Event{} = event} = Dashboard.update_event(event, update_attrs)
      assert event.attributes == %{}
      assert event.user_id == "some updated user_id"
      assert event.event_time == ~U[2024-04-04 12:38:00Z]
      assert event.event_name == "some updated event_name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_event(event, @invalid_attrs)
      assert event == Dashboard.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Dashboard.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_event(event)
    end
  end
end
