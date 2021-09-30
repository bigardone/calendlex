defmodule Calendlex.Event.Repo do
  alias Calendlex.{Event, Repo}
  import Ecto.Query

  def get(id) do
    Event
    |> Repo.get(id)
    |> Repo.preload(:event_type)
    |> case do
      nil ->
        {:error, :not_found}

      event ->
        {:ok, event}
    end
  end

  def insert(params) do
    params
    |> Event.changeset()
    |> Repo.insert()
  end

  def active_by_date(date) do
    Event
    |> where([e], fragment("?::date", e.start_at) == ^date)
    |> where([e], is_nil(e.cancelled_at))
    |> order_by(:start_at)
    |> Repo.all()
  end

  def cancel(id) do
    Event
    |> Repo.get!(id)
    |> Event.changeset(%{cancelled_at: DateTime.utc_now()})
    |> Repo.update()
  end

  def search(params) do
    Event
    |> order_by(:start_at)
    |> do_search(params)
    |> Repo.all()
  end

  defp do_search(query, params) do
    now = DateTime.utc_now()

    params
    |> Enum.reduce(query, fn {key, value}, acc ->
      case {key, value} do
        {"period", "upcoming"} ->
          from e in acc, where: e.start_at >= ^now

        {"period", "past"} ->
          from e in acc, where: e.end_at < ^now

        {"event_type_id", event_type_ids} when is_list(event_type_ids) ->
          from e in acc, where: e.event_type_id in ^event_type_ids

        {"status", ["active"]} ->
          from e in acc, where: is_nil(e.cancelled_at)

        {"status", ["cancelled"]} ->
          from e in acc, where: not is_nil(e.cancelled_at)

        _ ->
          acc
      end
    end)
    |> preload([:event_type])
  end
end
