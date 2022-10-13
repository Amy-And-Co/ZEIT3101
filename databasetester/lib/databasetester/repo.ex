defmodule Databasetester.Repo do
  use Ecto.Repo,
    otp_app: :databasetester,
    adapter: Ecto.Adapters.Postgres
end
