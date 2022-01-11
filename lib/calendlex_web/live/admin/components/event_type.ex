defmodule CalendlexWeb.Admin.Components.EventType do
  use CalendlexWeb, :live_component

  alias CalendlexWeb.Admin.Components.Dropdown

  @impl LiveComponent
  def mount(socket) do
    {:ok, socket}
  end

  @impl LiveComponent
  def handle_event("clone_me", _params, socket) do
    event_type = socket.assigns.event_type

    case Calendlex.clone_event_type(event_type) do
      {:ok, new_event_type} ->
        {:noreply,
         push_redirect(socket,
           to: Routes.live_path(socket, CalendlexWeb.Admin.EditEventTypeLive, new_event_type.id)
         )}

      {:error, _} ->
        send(self(), :clone_error)
        {:noreply, socket}
    end
  end

  def handle_event("delete_me", _params, socket) do
    event_type = socket.assigns.event_type

    send(self(), {:confirm_delete, event_type})

    {:noreply, socket}
  end
end
