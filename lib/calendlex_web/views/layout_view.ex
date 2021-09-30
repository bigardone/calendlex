defmodule CalendlexWeb.LayoutView do
  use CalendlexWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

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

  def admin_nav_link_classes(is_current) do
    class_list([
      {"py-6 font-medium text-gray-400 border-b-2 border-white hover:border-gray-400 hover:text-gray-600",
       true},
      {"text-gray-600 border-blue-500 hover:text-gray-600 hover:border-blue-500", is_current}
    ])
  end

  def class_list(items) do
    items
    |> Enum.reject(&(elem(&1, 1) == false))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(" ")
  end
end
