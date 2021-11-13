defmodule Calendlex.EventType.Repo do
  import Ecto.Query, only: [where: 3, order_by: 3]

  alias Calendlex.{EventType, Repo}

  def available do
    EventType
    |> where([e], is_nil(e.deleted_at))
    |> order_by([e], e.name)
    |> Repo.all()
  end

  def get_by_slug(slug) do
    case Repo.get_by(EventType, slug: slug) do
      nil ->
        {:error, :not_found}

      event_type ->
        {:ok, event_type}
    end
  end

  def get(id) do
    case Repo.get(EventType, id) do
      nil ->
        {:error, :not_found}

      event_type ->
        {:ok, event_type}
    end
  end

  def insert(params) do
    params
    |> EventType.changeset()
    |> Repo.insert()
  end

  def update(event_type, params) do
    event_type
    |> EventType.changeset(params)
    |> Repo.update()
  end

  def clone(%EventType{name: name, slug: slug} = event_type) do
    event_type
    |> Map.from_struct()
    |> Map.put(:name, "#{name} (clone)")
    |> Map.put(:slug, "#{slug}-clone")
    |> insert()
  end

  def delete(%EventType{name: name, slug: slug} = event_type) do
    params = %{
      name: "#{name} (deleted)",
      slug: "#{slug}-deleted",
      deleted_at: DateTime.utc_now()
    }

    event_type
    |> EventType.changeset(params)
    |> Repo.update()
  end
end
