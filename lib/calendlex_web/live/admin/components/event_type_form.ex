defmodule CalendlexWeb.Admin.Components.EventTypeForm do
  use CalendlexWeb, :live_component

  alias Calendlex.EventType
  alias Phoenix.LiveComponent

  @impl LiveComponent
  def update(
        %{event_type: %EventType{color: current_color} = event_type, changeset: changeset},
        socket
      ) do
    {:ok,
     assign(socket, event_type: event_type, changeset: changeset, current_color: current_color)}
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

  defp input_classes(form, field, default_classes \\ "w-full p-2 border rounded-md") do
    class_list([
      {default_classes, true},
      {"border-red-500", Keyword.has_key?(form.errors, field)}
    ])
  end
end
