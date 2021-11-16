defmodule CalendlexWeb.PageLive do
  use CalendlexWeb, :live_view

  alias CalendlexWeb.Components.EventType

  @impl LiveView
  def mount(_params, _session, socket) do
    event_types = Calendlex.available_event_types()

    {:ok, assign(socket, event_types: event_types), temporary_assigns: [event_types: []]}
  end
end
