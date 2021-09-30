defmodule Calendlex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Calendlex.Repo,
      # Start the Telemetry supervisor
      CalendlexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Calendlex.PubSub},
      # Start the Endpoint (http/https)
      CalendlexWeb.Endpoint
      # Start a worker by calling: Calendlex.Worker.start_link(arg)
      # {Calendlex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Calendlex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CalendlexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
