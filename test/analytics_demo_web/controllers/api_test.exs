defmodule AnalyticsDemoWeb.ApiTest do
  use AnalyticsDemoWeb.ConnCase, async: true
  alias AnalyticsDemo.Dashboard

  test "api to store an event", %{conn: conn} do
    conn =
      post(conn, ~p"/api/events", %{
        "user_id" => "user1",
        "event_name" => "subscription_activated",
        "attributes" => %{"plan" => "pro"}
      })

    assert response(conn, 201) == "created"
  end

  test "api to store an event when user pass event_time from past", %{conn: conn} do
    conn =
      post(conn, ~p"/api/events", %{
        "user_id" => "user1",
        "event_name" => "subscription_activated",
        "event_time" => "2024-04-01T12:00:00Z",
        "attributes" => %{"plan" => "pro"}
      })

    assert response(conn, 201) == "created"
  end

  test "api to store an event when user pass event_time from past when user passes a invalid event time",
       %{conn: conn} do
    conn =
      post(conn, ~p"/api/events", %{
        "user_id" => "user1",
        "event_name" => "subscription_activated",
        "event_time" => "2024-04-01T28:00:00Z",
        "attributes" => %{"plan" => "pro"}
      })

    assert json_response(conn, 422) == %{"errors" => %{"event_time" => ["is invalid"]}}
  end

  # test "api to store an event when user pass user_id with special character",
  #      %{conn: conn} do
  #   conn =
  #     post(conn, ~p"/api/events", %{
  #       "user_id" => "user1@",
  #       "event_name" => "subscription_activated",
  #       "event_time" => "2024-04-01T12:00:00Z",
  #       "attributes" => %{"plan" => "pro"}
  #     })

  #   assert json_response(conn, 422) == %{"errors" => %{"event_time" => ["is invalid"]}}
  # end

  test "api to return list of users", %{conn: conn} do
    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_deactivated",
      "event_time" => "2024-04-02T14:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user2",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "student", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T15:00:00Z",
      "attributes" => %{"plan" => "mini", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-03T08:00:00Z",
      "attributes" => %{"plan" => "proffesional", "billing_interval" => "monthly"}
    })

    conn = get(conn, ~p"/api/user_analytics")

    expected = %{
      "data" => [
        %{"event_count" => 2, "last_event_at" => "2024-04-03T08:00:00Z", "user" => "user3"},
        %{"event_count" => 2, "last_event_at" => "2024-04-02T14:00:00Z", "user" => "user1"},
        %{"event_count" => 1, "last_event_at" => "2024-04-01T12:00:00Z", "user" => "user2"}
      ]
    }

    assert json_response(conn, 200) == expected
  end

  test "api to return list of users when event_name is subscription_activated", %{conn: conn} do
    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_deactivated",
      "event_time" => "2024-04-02T14:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user2",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "student", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T15:00:00Z",
      "attributes" => %{"plan" => "mini", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-03T08:00:00Z",
      "attributes" => %{"plan" => "proffesional", "billing_interval" => "monthly"}
    })

    conn = get(conn, ~p"/api/user_analytics", %{"event_name" => "subscription_activated"})

    expected = %{
      "data" => [
        %{"event_count" => 2, "last_event_at" => "2024-04-03T08:00:00Z", "user" => "user3"},
        %{"event_count" => 1, "last_event_at" => "2024-04-01T12:00:00Z", "user" => "user2"},
        %{"event_count" => 1, "last_event_at" => "2024-04-01T12:00:00Z", "user" => "user1"}
      ]
    }

    assert json_response(conn, 200) == expected
  end

  test "api to return list of events between 2024-04-01 to 2024-04-05", %{conn: conn} do
    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_deactivated",
      "event_time" => "2024-04-02T14:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user2",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "student", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T15:00:00Z",
      "attributes" => %{"plan" => "mini", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-03T08:00:00Z",
      "attributes" => %{"plan" => "proffesional", "billing_interval" => "monthly"}
    })

    conn = get(conn, ~p"/api/event_analytics", %{"from" => "2024-04-01", "to" => "2024-04-05"})

    expected = %{
      "data" => [
        %{"count" => 3, "date" => "2024-04-01", "unique_count" => 3},
        %{"count" => 1, "date" => "2024-04-02", "unique_count" => 1},
        %{"count" => 1, "date" => "2024-04-03", "unique_count" => 1}
      ]
    }

    assert json_response(conn, 200) == expected
  end

  test "api to return list of events between 2024-04-01 to 2024-04-05 when the event name is subscription deactivated",
       %{conn: conn} do
    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user1",
      "event_name" => "subscription_deactivated",
      "event_time" => "2024-04-02T14:00:00Z",
      "attributes" => %{"plan" => "pro", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user2",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T12:00:00Z",
      "attributes" => %{"plan" => "student", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-01T15:00:00Z",
      "attributes" => %{"plan" => "mini", "billing_interval" => "monthly"}
    })

    Dashboard.create_event(%{
      "user_id" => "user3",
      "event_name" => "subscription_activated",
      "event_time" => "2024-04-03T08:00:00Z",
      "attributes" => %{"plan" => "proffesional", "billing_interval" => "monthly"}
    })

    conn =
      get(conn, ~p"/api/event_analytics", %{
        "from" => "2024-04-01",
        "to" => "2024-04-05",
        "event_name" => "subscription_deactivated"
      })

    expected = %{"data" => [%{"count" => 1, "date" => "2024-04-02", "unique_count" => 1}]}
    assert json_response(conn, 200) == expected
  end
end
