defmodule AnalyticsDemo.Dashboard do
  @moduledoc """
  The Dashboard context.
  """

  import Ecto.Query, warn: false
  alias AnalyticsDemo.Repo

  alias AnalyticsDemo.Dashboard.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    attrs = Enum.into(attrs, %{"event_time" => DateTime.utc_now()})

    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def list_events_by_users(params \\ %{}) do
    Event
    |> search_event_params(params)
    |> select([e], %{
      user: e.user_id,
      event_count: count(e.event_name),
      last_event_at: max(e.event_time)
    })
    |> group_by([e], :user_id)
    |> order_by([e], desc: max(e.event_time))
    |> Repo.all()
  end

  def search_event_params(query, %{"event_name" => event}) when event not in [nil, ""],
    do: where(query, [e], e.event_name == ^event)

  def search_event_params(query, _params), do: query

  def list_events_per_date(params) do
    with {:ok, from} <- verify_date(params, "from"),
         {:ok, to} <- verify_date(params, "to"),
         {:ok, dates} <- verify_from_is_greater_than_to(from, to) do
      {:ok, list_events_per_date(dates, params)}
    end
  end

  def list_events_per_date(%{"from" => from, "to" => to}, params) do
    Event
    |> where(
      [e],
      fragment("date(?)", e.event_time) >= ^from and fragment("date(?)", e.event_time) <= ^to
    )
    |> search_event_params(params)
    |> select([e], %{
      date: fragment("date(?)", e.event_time),
      count: count(e.event_name),
      unique_count: count(e.user_id, :distinct)
    })
    |> group_by([e], fragment("date(?)", e.event_time))
    |> order_by([e], asc: fragment("date(?)", e.event_time))
    |> Repo.all()
  end

  def verify_date(params, key) do
    Map.get(params, key, nil)
    |> do_verify_date(key)
  end

  def do_verify_date(nil, key), do: {:error, "please enter valid #{key}"}

  def do_verify_date(date, key) do
    case Date.from_iso8601(date) do
      {:ok, date} -> {:ok, date}
      {:error, error} -> {:error, "error in #{key}: #{error}"}
    end
  end

  def verify_from_is_greater_than_to(from, to) do
    case Date.compare(from, to) do
      dt when dt in [:eq, :lt] -> {:ok, %{"from" => from, "to" => to}}
      :gt -> {:error, "from must not be greater than to"}
    end
  end
end
