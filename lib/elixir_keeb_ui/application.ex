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

    children = case Mix.env() do
      :local ->
        [
          %{
            id: Fake.DataSource,
            # TODO: length of fake data should come from config,
            # same value that controls number of Barchart "categories"
            start: {ElixirKeeb.UI.DataFaker, :new, [[50, [name: Fake.DataSource]]]}
          }
          | children
        ]
      _ ->
        children
    end

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
