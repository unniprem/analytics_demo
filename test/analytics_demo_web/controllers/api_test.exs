defmodule AnalyticsDemoWeb.ApiTest do
  use AnalyticsDemoWeb.ConnCase, async: true

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

  test "api to store an event when user pass user_id with special character",
       %{conn: conn} do
    conn =
      post(conn, ~p"/api/events", %{
        "user_id" => "user1@",
        "event_name" => "subscription_activated",
        "event_time" => "2024-04-01T12:00:00Z",
        "attributes" => %{"plan" => "pro"}
      })

    assert json_response(conn, 422) == %{"errors" => %{"event_time" => ["is invalid"]}}
  end
end
