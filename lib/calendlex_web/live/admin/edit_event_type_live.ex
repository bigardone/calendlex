defmodule CalendlexWeb.Admin.EditEventTypeLive do
  use CalendlexWeb, :admin_live_view

  alias Calendlex.EventType

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    case Calendlex.get_event_type_by_id(id) do
      {:ok, %EventType{name: name} = event_type} ->
        socket =
          socket
          |> assign(section: "event_types")
          |> assign(page_title: name)
          |> assign(event_type: event_type)
          |> assign(changeset: EventType.changeset(event_type, %{}))

        {:ok, socket}

      _ ->
        {:ok, socket, layout: {CalendlexWeb.LayoutView, "not_found.html"}}
    end
  end

  @impl true
  def handle_event("build_slug", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:submit, params}, %{assigns: %{event_type: event_type}} = socket) do
    event_type
    |> Calendlex.update_event_type(params)
    |> case do
      {:ok, event_type} ->
        socket =
          socket
          |> put_flash(:info, "Saved")
          |> assign(event_type: event_type)
          |> assign(changeset: EventType.changeset(event_type, %{}))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
