defmodule ElixirKeeb.UI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  @mix_env Mix.env()

  def start(_type, _args) do
    Logger.info("⌨️  Starting ElixirKeeb.UI 2022/06/27 22:31:08 ⌨️,")

    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      ElixirKeeb.UIWeb.Endpoint,
      {Phoenix.PubSub, [name: ElixirKeeb.UI.PubSub, adapter: Phoenix.PubSub.PG2]}
    ]

    children = case @mix_env do
      :local ->
        [
          fake_datasource_spec(Fake.DataSource1, 50),
          fake_datasource_spec(Fake.DataSource2, 30)
        ] ++ children
      _ ->
        children
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirKeeb.UI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp fake_datasource_spec(name, how_many) do
    %{
      id: name,
      # TODO: length of fake data should come from config,
      # same value that controls number of Barchart "categories"
      start: {
        ElixirKeeb.UI.DataFaker,
        :new,
        [[how_many, [name: name]]]
      }
    }
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirKeeb.UIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
