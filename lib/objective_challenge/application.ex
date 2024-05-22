defmodule ObjectiveChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ObjectiveChallengeWeb.Telemetry,
      ObjectiveChallenge.Repo,
      {DNSCluster, query: Application.get_env(:objective_challenge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ObjectiveChallenge.PubSub},
      # Start a worker by calling: ObjectiveChallenge.Worker.start_link(arg)
      # {ObjectiveChallenge.Worker, arg},
      # Start to serve requests, typically the last entry
      ObjectiveChallengeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ObjectiveChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObjectiveChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
