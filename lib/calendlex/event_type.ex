defmodule Calendlex.EventType do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "event_types" do
    field :description, :string
    field :duration, :integer
    field :name, :string
    field :slug, :string
    field :color, :string
    field :deleted_at, :utc_datetime

    timestamps()
  end

  @fields ~w(name description slug duration color deleted_at)a
  @required_fields ~w(name slug duration color)a

  @doc false
  def changeset(event_type \\ %EventType{}, attrs) do
    event_type
    |> cast(attrs, @fields)
    |> build_slug()
    |> validate_required(@required_fields)
    |> unique_constraint(:slug, name: "event_types_slug_index")
  end

  def delete_changeset(event_type) do
    event_type
    |> with_deleted_changes()
    |> validate_required(@required_fields)
  end

  defp build_slug(%{changes: %{name: name}} = changeset) do
    put_change(changeset, :slug, Slug.slugify(name))
  end

  defp build_slug(changeset), do: changeset

  defp with_deleted_changes(%{name: name, slug: slug} = event_type) do
    event_type
    |> Changeset.change()
    |> put_change(:name, "#{name} (deleted)")
    |> put_change(:slug, "#{slug}-deleted-#{:os.system_time(:millisecond)}")
    |> put_change(:deleted_at, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
