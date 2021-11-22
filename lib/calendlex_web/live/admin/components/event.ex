defmodule CalendlexWeb.Admin.Components.Event do
  use CalendlexWeb, :live_component

  alias Calendlex.Event
  alias Phoenix.LiveView.JS

  @impl LiveComponent
  def update(%{event: event, time_zone: time_zone}, socket) do
    {:ok, assign(socket, event: event, time_zone: time_zone)}
  end

  defp format_time(%{start_at: start_at, end_at: end_at}, time_zone) do
    slot_start_str =
      start_at
      |> DateTime.shift_zone!(time_zone)
      |> Timex.format!("{h24}:{m}")

    slot_end_str =
      end_at
      |> DateTime.shift_zone!(time_zone)
      |> Timex.format!("{h24}:{m}")

    "#{slot_start_str} - #{slot_end_str}"
  end

  defp cancelled_classes(event, classes) do
    cancelled = not Event.is_active(event)

    class_list([
      {classes, true},
      {"line-through", cancelled}
    ])
  end
end
