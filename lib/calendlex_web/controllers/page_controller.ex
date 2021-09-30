defmodule CalendlexWeb.PageController do
  use CalendlexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
