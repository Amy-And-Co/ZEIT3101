defmodule Amyandco.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Amyandco.Repo,
      # Start the Telemetry supervisor
      AmyandcoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Amyandco.PubSub},
      # Start the Endpoint (http/https)
      AmyandcoWeb.Endpoint,
      # Start a worker by calling: Amyandco.Worker.start_link(arg)
      # {Amyandco.Worker, arg}
      AmyandcoWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Amyandco.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AmyandcoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
