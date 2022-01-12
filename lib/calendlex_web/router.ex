defmodule CalendlexWeb.Router do
  use CalendlexWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CalendlexWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug :basic_auth, Application.compile_env(:calendlex, :basic_auth)
  end

  live_session :private, on_mount: {CalendlexWeb.Live.InitAssigns, :private} do
    scope "/admin", CalendlexWeb.Admin do
      pipe_through :browser
      pipe_through :auth

      live "/", EventTypesLive
      live "/event_types/new", NewEventTypeLive
      live "/event_types/:id", EditEventTypeLive
      live "/scheduled_events", ScheduledEventsLive
    end
  end

  live_session :public, on_mount: CalendlexWeb.Live.InitAssigns do
    scope "/", CalendlexWeb do
      pipe_through :browser

      live "/", PageLive
      live "/:event_type_slug", EventTypeLive
      live "/:event_type_slug/:time_slot", ScheduleEventLive
      live "/events/:event_type_slug/:event_id", EventsLive
    end
  end
end
