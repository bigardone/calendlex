defmodule Calendlex.Repo do
  use Ecto.Repo,
    otp_app: :calendlex,
    adapter: Ecto.Adapters.Postgres
end
