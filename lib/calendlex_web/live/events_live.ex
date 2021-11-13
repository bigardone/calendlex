defmodule CalendlexWeb.EventsLive do
  use CalendlexWeb, :live_view

  @impl LiveView
  def mount(%{"event_type_slug" => slug, "event_id" => id}, _session, socket) do
    with {:ok, event_type} <- Calendlex.get_event_type_by_slug(slug),
         {:ok, event} <- Calendlex.get_event_by_id(id) do
      socket =
        socket
        |> assign(event_type: event_type)
        |> assign(event: event)

      {:ok, socket}
    else
      {:error, :not_found} ->
        {:ok, socket, layout: {CalendlexWeb.LayoutView, "not_found.html"}}
    end
  end
end
