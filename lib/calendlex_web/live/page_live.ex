defmodule CalendlexWeb.PageLive do
  use CalendlexWeb, :live_view

  alias Calendlex.EventType
  alias CalendlexWeb.Components.EventType

  @impl true
  def mount(_params, _session, socket) do
    event_types = Calendlex.event_types()

    {:ok, assign(socket, event_types: event_types)}
  end
end
