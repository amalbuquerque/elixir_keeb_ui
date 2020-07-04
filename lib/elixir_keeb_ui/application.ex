defmodule ElixirKeeb.UI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    Logger.info("⌨️ Starting ElixirKeeb.UI ⌨️,")

    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      ElixirKeeb.UIWeb.Endpoint,
      {Phoenix.PubSub, [name: ElixirKeeb.UI.PubSub, adapter: Phoenix.PubSub.PG2]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirKeeb.UI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirKeeb.UIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
