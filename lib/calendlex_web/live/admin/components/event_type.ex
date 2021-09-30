defmodule CalendlexWeb.Admin.Components.EventType do
  use CalendlexWeb, :live_component

  alias CalendlexWeb.Admin.Components.Dropdown

  @impl LiveComponent
  def update(%{event_type: event_type}, socket) do
    {:ok, assign(socket, event_type: event_type)}
  end

  @impl LiveComponent
  def handle_event("clone_me", _params, socket) do
    event_type = socket.assigns.event_type

    {:ok, new_event_type} = Calendlex.clone_event_type(event_type)

    {:noreply,
     push_redirect(socket,
       to: Routes.live_path(socket, CalendlexWeb.Admin.EditEventTypeLive, new_event_type.id)
     )}
  end

  def handle_event("delete_me", _params, socket) do
    event_type = socket.assigns.event_type

    send(self(), {:confirm_delete, event_type})

    {:noreply, socket}
  end
end
