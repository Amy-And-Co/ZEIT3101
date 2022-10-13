defmodule Amyandco.Repo do
  use Ecto.Repo,
    otp_app: :amyandco,
    adapter: Ecto.Adapters.Postgres
end
