defmodule Calendlex.TimeSlots do
  alias Calendlex.Event.Repo, as: EventRepo

  @day_start 9
  @day_end 19

  @spec build(Date.t(), String.t(), non_neg_integer) :: [DateTime.t()]
  def build(date, time_zone, duration) do
    day_start =
      date
      |> Timex.to_datetime(time_zone)
      |> Timex.set(hour: @day_start)

    day_end = Timex.set(day_start, hour: @day_end)

    date_events = EventRepo.active_by_date(date)

    day_start
    |> Stream.iterate(&DateTime.add(&1, duration * 60, :second))
    |> Stream.take_while(&(DateTime.diff(day_end, &1) > 0))
    |> Stream.reject(&reject_overlaps(&1, date_events, duration))
    |> Enum.to_list()
  end

  defp reject_overlaps(time_slot, date_events, duration) do
    next_time_slot = DateTime.add(time_slot, duration * 60, :second)

    Enum.any?(date_events, fn event ->
      if DateTime.compare(event.start_at, time_slot) == :lt do
        DateTime.compare(event.end_at, time_slot) == :gt
      else
        DateTime.compare(event.start_at, next_time_slot) == :lt
      end
    end)
  end
end
