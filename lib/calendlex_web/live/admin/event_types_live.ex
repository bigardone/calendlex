defmodule CalendlexWeb.Admin.EventTypesLive do
  use CalendlexWeb, :admin_live_view

  alias CalendlexWeb.Admin.Components.Modal

  @impl true
  def mount(_params, _session, socket) do
    event_types = Calendlex.available_event_types()

    socket =
      socket
      |> assign(event_types: event_types)
      |> assign(section: "event_types")
      |> assign(page_title: "Event types")
      |> assign(delete_event_type: nil)

    {:ok, socket, temporary_assigns: [event_types: []]}
  end

  @impl true
  def handle_info({:confirm_delete, event_type}, socket) do
    {:noreply, assign(socket, delete_event_type: event_type)}
  end

  @impl true
  def handle_event("delete", _, socket) do
    event_type = socket.assigns.delete_event_type

    {:ok, _} = Calendlex.delete_event_type(event_type)

    socket =
      socket
      |> assign(delete_event_type: nil)
      |> update(:event_types, fn _ -> Calendlex.available_event_types() end)
      |> put_flash(:info, "Deleted")

    {:noreply, socket}
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, delete_event_type: nil)}
  end
end
