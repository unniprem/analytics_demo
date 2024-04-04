defmodule AnalyticsDemo.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :user_id, :string
      add :event_time, :utc_datetime
      add :event_name, :string
      add :attributes, :map

      timestamps()
    end
  end
end
