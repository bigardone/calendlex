defmodule CalendlexWeb.EventTypeLive do
  use CalendlexWeb, :live_view

  alias Timex.Duration

  @impl LiveView
  def mount(%{"event_type_slug" => slug} = params, _session, socket) do
    case Calendlex.get_event_type_by_slug(slug) do
      {:ok, event_type} ->
        socket =
          socket
          |> assign(event_type: event_type)
          |> assign(page_title: event_type.name)
          |> assign_dates(params)
          |> assign_time_slots(params)

        {:ok, socket, temporary_assigns: [time_slots: []]}

      {:error, :not_found} ->
        {:ok, socket, layout: {CalendlexWeb.LayoutView, "not_found.html"}}
    end
  end

  @impl LiveView
  def handle_event("next_month", _, socket) do
    socket.assigns.current
    |> Timex.end_of_month()
    |> Timex.add(Duration.from_days(1))
    |> shift_month(socket)
  end

  def handle_event("previous_month", _, socket) do
    socket.assigns.current
    |> Timex.beginning_of_month()
    |> Timex.add(Duration.from_days(-1))
    |> shift_month(socket)
  end

  @impl LiveView
  def handle_info({:select_day, date}, socket) do
    socket =
      socket
      |> assign(current: date)
      |> assign_time_slots(%{"date" => date})
      |> push_patch(
        to:
          Routes.live_path(socket, CalendlexWeb.EventTypeLive, socket.assigns.event_type.slug,
            date: Date.to_iso8601(date)
          ),
        replace: true
      )

    {:noreply, socket}
  end

  @impl LiveView
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  defp assign_dates(socket, params) do
    current = current_from_params(params, socket)
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    socket
    |> assign(beginning_of_month: beginning_of_month)
    |> assign(current: current)
    |> assign(end_of_month: end_of_month)
  end

  defp assign_time_slots(socket, %{"date" => _}) do
    date = socket.assigns.current
    owner_time_zone = socket.assigns.admin.time_zone
    event_duration = socket.assigns.event_type.duration

    time_slots = Calendlex.build_time_slots(date, owner_time_zone, event_duration)

    socket
    |> assign(time_slots: time_slots)
    |> assign(selected_date: date)
  end

  defp assign_time_slots(socket, _), do: socket

  defp current_from_params(%{"date" => date}, socket) do
    case Timex.parse(date, "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(socket.assigns.time_zone)
    end
  end

  defp current_from_params(_, socket) do
    Timex.today(socket.assigns.time_zone)
  end

  defp shift_month(current, socket) do
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    socket =
      socket
      |> assign(current: current)
      |> assign(beginning_of_month: beginning_of_month)
      |> assign(end_of_month: end_of_month)

    {:noreply, socket}
  end
end
