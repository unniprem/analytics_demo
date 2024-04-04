# AnalyticsDemo

To start your Phoenix server:

- Run `mix setup` to do initail setup
- Run `mix phx.server` to run the application

### To test the api run the following command in a terminal

- To create new event

```
curl -X POST 'http://localhost:4000/api/events?user_id=user_id1&event_name=subscription_activated'
```

- To return list of users

```
curl 'http://localhost:4000/api/user_analytics'
```

- To return list of users for a event

```
curl 'http://localhost:4000/api/user_analytics?event_name=subscription_activated'
```

- To return aggregated event counts over time

```
curl 'http://localhost:4000/api/event_analytics?event_name=subscription_activated&from=2024-01-02&to=2024-02-03'
```

- Run `mix test` to run test cases
