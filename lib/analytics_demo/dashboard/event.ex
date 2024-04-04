defmodule AnalyticsDemo.Dashboard.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :attributes, :map
    field :user_id, :string
    field :event_time, :utc_datetime
    field :event_name, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:user_id, :event_time, :event_name, :attributes])
    |> validate_required([:user_id, :event_name])
    |> validate_format(:user_id, ~r/[A-Za-z0-9\._-]/)
  end
end
