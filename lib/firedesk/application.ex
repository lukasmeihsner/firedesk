defmodule Firedesk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FiredeskWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Firedesk.PubSub},
      # Start Finch
      {Finch, name: Firedesk.Finch},
      # Start the Endpoint (http/https)
      FiredeskWeb.Endpoint,
      # Start a worker by calling: Firedesk.Worker.start_link(arg)
      # {Firedesk.Worker, arg}
      Firedesk.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firedesk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FiredeskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
