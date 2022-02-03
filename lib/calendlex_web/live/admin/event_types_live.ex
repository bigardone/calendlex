defmodule CalendlexWeb.Admin.EventTypesLive do
  use CalendlexWeb, :admin_live_view

  alias CalendlexWeb.Admin.Components.Modal

  @impl LiveView
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [event_types: []]}
  end

  @impl LiveView
  def handle_params(_, _, socket) do
    event_types = Calendlex.available_event_types()

    socket =
      socket
      |> assign(event_types: event_types)
      |> assign(event_types_count: length(event_types))
      |> assign(section: "event_types")
      |> assign(page_title: "Event types")
      |> assign(delete_event_type: nil)

    {:noreply, socket}
  end

  @impl LiveView
  def handle_info({:confirm_delete, event_type}, socket) do
    {:noreply, assign(socket, delete_event_type: event_type)}
  end

  def handle_info(:clone_error, socket) do
    {:noreply, put_flash(socket, :error, "A similar event type already exists")}
  end

  @impl LiveView
  def handle_event("delete", _, socket) do
    event_type = socket.assigns.delete_event_type

    {:ok, _} = Calendlex.delete_event_type(event_type)

    socket =
      socket
      |> put_flash(:info, "Deleted")
      |> push_patch(to: Routes.live_path(socket, __MODULE__))

    {:noreply, socket}
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, delete_event_type: nil)}
  end
end
