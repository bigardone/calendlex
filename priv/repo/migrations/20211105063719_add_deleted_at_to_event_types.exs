defmodule Calendlex.Repo.Migrations.AddDeletedAtToEventTypes do
  use Ecto.Migration

  def change do
    alter table(:event_types) do
      add :deleted_at, :utc_datetime
    end
  end
end
