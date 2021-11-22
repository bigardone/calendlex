defmodule CalendlexWeb.Components.CalendarDay do
  use CalendlexWeb, :live_component

  @impl LiveComponent
  def update(%{date: date, time_zone: time_zone} = assigns, socket) do
    weekday = Timex.weekday(date, :monday)
    disabled = Timex.compare(date, Timex.today(time_zone)) == -1

    classes =
      class_list([
        {"content-center w-10 h-10 rounded-full text-center col-start-#{weekday}", true},
        {"bg-blue-50 text-blue-600 font-bold hover:bg-blue-200", not disabled},
        {"text-gray-200 cursor-default", disabled}
      ])

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:date, date)
     |> assign(:disabled, disabled)
     |> assign(:text, Timex.format!(date, "{D}"))
     |> assign(:classes, classes)}
  end

  @impl LiveComponent
  def handle_event("select", _, %{assigns: %{date: date}} = socket) do
    send(self(), {:select_day, date})

    {:noreply, socket}
  end
end
