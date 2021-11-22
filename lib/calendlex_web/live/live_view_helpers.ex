defmodule CalendlexWeb.LiveViewHelpers do
  def schedule_string(start_at, end_at, time_zone) do
    slot_start_str =
      start_at
      |> DateTime.shift_zone!(time_zone)
      |> Timex.format!("{h24}:{m}")

    slot_end_str =
      end_at
      |> DateTime.shift_zone!(time_zone)
      |> Timex.format!("{h24}:{m}")

    date_str =
      start_at
      |> DateTime.shift_zone!(time_zone)
      |> Timex.format!("{WDfull}, {Mfull} {D}, {YYYY}")

    "#{slot_start_str} - #{slot_end_str}, #{date_str}"
  end

  def class_list(items) do
    items
    |> Enum.reject(&(elem(&1, 1) == false))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(" ")
  end
end
