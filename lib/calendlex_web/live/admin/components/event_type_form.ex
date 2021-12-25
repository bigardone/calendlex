defmodule CalendlexWeb.Admin.Components.EventTypeForm do
  use CalendlexWeb, :live_component

  alias Calendlex.EventType
  alias Phoenix.LiveComponent

  @impl LiveComponent
  def update(
        %{event_type: %EventType{color: current_color} = event_type, changeset: changeset},
        socket
      ) do
    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(event_type: event_type)
      |> assign(current_color: current_color)
      |> assign(public_url: "")

    {:ok, socket}
  end

  @impl LiveComponent
  def handle_event(
        "change",
        %{"event_type" => params},
        %{assigns: %{event_type: event_type}} = socket
      ) do
    changeset = EventType.changeset(event_type, params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("set_color", %{"color" => color}, %{assigns: %{changeset: changeset}} = socket) do
    changeset = Ecto.Changeset.put_change(changeset, :color, color)

    {:noreply, assign(socket, changeset: changeset, current_color: color)}
  end

  def handle_event("submit", %{"event_type" => params}, socket) do
    send(self(), {:submit, params})

    {:noreply, socket}
  end

  defp color_classes(color) do
    "inline-block w-8 h-8 #{color}-bg rounded-full"
  end

  defp public_url(socket, changeset) do
    slug = Map.get(changeset.data, :slug) || Map.get(changeset.changes, :slug, "")
    Routes.live_url(socket, CalendlexWeb.EventTypeLive, slug)
  end
end
