defmodule Poca.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PocaWeb.Telemetry,
      Poca.Repo,
      {Oban, Application.fetch_env!(:poca, Oban)},
      {DNSCluster, query: Application.get_env(:poca, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Poca.PubSub},
      PocaWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Poca.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PocaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
