defmodule CalendlexWeb.ScheduleEventLive do
  use CalendlexWeb, :live_view

  alias Calendlex.Event

  @impl LiveView
  def mount(%{"event_type_slug" => slug, "time_slot" => time_slot}, _session, socket) do
    with {:ok, event_type} <- Calendlex.get_event_type_by_slug(slug),
         {:ok, start_at, _} <- DateTime.from_iso8601(time_slot) do
      end_at = Timex.add(start_at, Timex.Duration.from_minutes(event_type.duration))
      changeset = Event.changeset(%{})

      socket =
        socket
        |> assign(changeset: changeset)
        |> assign(end_at: end_at)
        |> assign(event_type: event_type)
        |> assign(start_at: start_at)

      {:ok, socket}
    else
      _ ->
        {:ok, socket, layout: {CalendlexWeb.LayoutView, "not_found.html"}}
    end
  end

  @impl LiveView
  def handle_event(
        "submit",
        %{"event" => event},
        %{
          assigns: %{
            end_at: end_at,
            event_type: event_type,
            start_at: start_at,
            time_zone: time_zone
          }
        } = socket
      ) do
    event
    |> Map.put("end_at", end_at)
    |> Map.put("event_type_id", event_type.id)
    |> Map.put("start_at", start_at)
    |> Map.put("time_zone", time_zone)
    |> Calendlex.insert_event()
    |> case do
      {:ok, event} ->
        {:noreply,
         push_redirect(socket,
           to: Routes.live_path(socket, CalendlexWeb.EventsLive, event_type.slug, event.id)
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
