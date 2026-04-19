defmodule Poca.Repo do
  use Ecto.Repo,
    otp_app: :poca,
    adapter: Ecto.Adapters.Postgres
end
