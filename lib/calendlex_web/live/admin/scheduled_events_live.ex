defmodule CalendlexWeb.Admin.ScheduledEventsLive do
  use CalendlexWeb, :admin_live_view

  alias CalendlexWeb.Admin.Components.Modal

  @upcoming_period "upcoming"
  @past_period "past"

  @impl true
  def mount(_params, _session, socket) do
    period = @upcoming_period
    events = %{}
    event_types = Calendlex.available_event_types()

    socket =
      socket
      |> assign(events: events)
      |> assign(section: "scheduled_events")
      |> assign(page_title: "Scheduled events")
      |> assign(period: period)
      |> assign(cancel_event: nil)
      |> assign(show_filter: false)
      |> assign(event_types: event_types)
      |> assign(filter_form: %{"period" => period, "status" => ["active"]})

    {:ok, socket, temporary_assigns: [events: %{}]}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    period =
      params
      |> Map.get("period")
      |> period_from_params()

    filter_form = Map.put(socket.assigns.filter_form, "period", period)

    socket =
      socket
      |> assign(period: upcoming_period())
      |> assign(period: period)
      |> assign(cancel_event: nil)
      |> assign(filter_form: filter_form)
      |> update(:events, fn _ -> search_events(filter_form) end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel_event", %{"id" => id}, socket) do
    {:ok, event} = Calendlex.get_event_by_id(id)

    {:noreply, assign(socket, cancel_event: event)}
  end

  def handle_event("show_filter", _, %{assigns: %{show_filter: show_filter}} = socket) do
    {:noreply, assign(socket, show_filter: not show_filter)}
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, cancel_event: nil)}
  end

  def handle_event("cancel", _, socket) do
    id = socket.assigns.cancel_event.id

    case Calendlex.cancel_event(id) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Cancelled")
          |> assign(cancel_event: nil)
          |> update(:events, fn _ -> search_events(socket.assigns.filter_form) end)

        {:noreply, socket}

      _ ->
        {:noreply, put_flash(socket, :error, "Error")}
    end
  end

  @impl true
  def handle_info({:filter_submit, filter_form}, socket) do
    socket =
      socket
      |> assign(filter_form: filter_form)
      |> update(:events, fn _ -> search_events(filter_form) end)

    {:noreply, socket}
  end

  defp nav_link_classes(is_current) do
    class_list([
      {"py-6 font-medium text-gray-400 border-b-2 border-white hover:border-gray-400 hover:text-gray-600",
       true},
      {"text-gray-600 border-blue-500 hover:text-gray-600 hover:border-blue-500", is_current}
    ])
  end

  defp format_date(date) do
    date
    |> Date.from_iso8601!()
    |> Timex.format!("{WDfull}, {D} {Mfull} {YYYY}")
  end

  defp upcoming_period, do: @upcoming_period

  defp past_period, do: @past_period

  defp search_events(filter_form) do
    filter_form
    |> Calendlex.search_events()
    |> Enum.group_by(&(&1.start_at |> DateTime.to_date() |> Date.to_iso8601()))
    |> Enum.sort()
  end

  defp period_from_params(@past_period), do: @past_period

  defp period_from_params(_), do: @upcoming_period
end
