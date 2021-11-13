defmodule CalendlexWeb.Admin.Components.EventsFilterForm do
  use CalendlexWeb, :live_component

  alias CalendlexWeb.Admin.Components.Dropdown

  @impl LiveComponent
  def update(%{form: form, event_types: event_types}, socket) do
    statuses = ~w(active cancelled)
    {:ok, assign(socket, event_types: event_types, statuses: statuses, form: form)}
  end

  @impl LiveComponent
  def handle_event("change", %{"form" => form}, socket) do
    {:noreply, assign(socket, form: form)}
  end

  @impl LiveComponent
  def handle_event("submit", %{"form" => form}, socket) do
    send(self(), {:filter_submit, form})

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("submit", _, socket) do
    send(self(), {:filter_submit, %{}})

    {:noreply, assign(socket, form: %{})}
  end

  def handle_event("reset", _, socket) do
    send(self(), {:filter_submit, %{"status" => ["active"]}})

    {:noreply, assign(socket, form: %{})}
  end

  defp event_types_text(%{"event_type_id" => event_types}) do
    case event_types do
      [] ->
        "All event types"

      [_] ->
        "1 event type"

      _ ->
        "#{length(event_types)} event types"
    end
  end

  defp event_types_text(_), do: "All event types"

  defp status_text(%{"status" => status}) do
    case status do
      ["active"] ->
        "Active events"

      ["cancelled"] ->
        "Cancelled events"

      _ ->
        "All events"
    end
  end

  defp status_text(_), do: "All events"

  defp is_event_type_selected(event_type_id, %{"event_type_id" => event_types}) do
    event_type_id in event_types
  end

  defp is_event_type_selected(_, _), do: false

  defp is_status_selected(status, %{"status" => statuses}) do
    status in statuses
  end

  defp is_status_selected(_, _), do: false
end
