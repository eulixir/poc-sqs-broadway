defmodule Poc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Poc.Repo,
      # Start the Telemetry supervisor
      PocWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Poc.PubSub},
      # Start the Endpoint (http/https)
      PocWeb.Endpoint,
      # Start a worker by calling: Poc.Worker.start_link(arg)
      # {Poc.Worker, arg}
      Poc.Broadway
      # Start a broadway supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Poc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PocWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
