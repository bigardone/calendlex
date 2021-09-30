defmodule Calendlex.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_at, :utc_datetime, null: false
      add :end_at, :utc_datetime, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :time_zone, :string, null: false
      add :comments, :text
      add :cancelled_at, :utc_datetime

      add :event_type_id, references(:event_types, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:events, [:event_type_id])
  end
end
