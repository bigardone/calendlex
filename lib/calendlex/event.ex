defmodule Calendlex.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Calendlex.EventType

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "events" do
    field :cancelled_at, :utc_datetime
    field :comments, :string
    field :email, :string
    field :end_at, :utc_datetime
    field :name, :string
    field :start_at, :utc_datetime
    field :time_zone, :string

    belongs_to(:event_type, EventType)

    timestamps()
  end

  @fields ~w(cancelled_at event_type_id start_at end_at name email comments time_zone)a
  @required_fields ~w(start_at end_at name email time_zone)a

  @doc false
  def changeset(event \\ %Event{}, attrs) do
    event
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def is_upcoming(%Event{start_at: start_at}) do
    DateTime.compare(start_at, DateTime.utc_now()) == :gt
  end

  def is_active(%Event{cancelled_at: nil}), do: true
  def is_active(_), do: false
end
