defmodule PrivateChat.Repo do
  use Ecto.Repo,
    otp_app: :privateChat,
    adapter: Ecto.Adapters.Postgres
end
