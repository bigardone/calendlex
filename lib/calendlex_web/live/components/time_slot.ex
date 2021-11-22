defmodule CalendlexWeb.Components.TimeSlot do
  use CalendlexWeb, :live_component

  @impl LiveComponent
  def update(%{event_type: event_type, time_slot: time_slot, time_zone: time_zone}, socket) do
    text =
      time_slot
      |> DateTime.shift_zone!(time_zone)
      |> Timex.format!("{h24}:{m}")

    {:ok,
     socket
     |> assign(:event_type, event_type)
     |> assign(:time_slot, time_slot)
     |> assign(:text, text)}
  end

  @impl LiveComponent
  def handle_event(
        "select",
        _,
        %{assigns: %{event_type: event_type, time_slot: time_slot}} = socket
      ) do
    slot_string = DateTime.to_iso8601(time_slot)

    url =
      socket
      |> Routes.live_path(CalendlexWeb.ScheduleEventLive, event_type.slug, slot_string)
      |> URI.decode()

    {:noreply, push_redirect(socket, to: url)}
  end
end
