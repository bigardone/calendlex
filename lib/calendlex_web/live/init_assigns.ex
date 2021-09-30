defmodule CalendlexWeb.Live.InitAssigns do
  import Phoenix.LiveView

  def on_mount(:user, _params, _session, socket) do
    admin = Application.get_env(:calendlex, :admin)
    time_zone = get_connect_params(socket)["timezone"] || admin.time_zone

    socket =
      socket
      |> assign(:time_zone, time_zone)
      |> assign(:admin, admin)

    {:cont, socket}
  end

  def on_mount(:admin, _params, _session, socket) do
    admin = Application.get_env(:calendlex, :admin)

    {:cont, assign(socket, :admin, admin)}
  end
end
