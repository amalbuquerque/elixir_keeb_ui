defmodule ElixirKeeb.UI.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_keeb_ui,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ElixirKeeb.UI.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6"},
      {:phoenix_pubsub, "~> 2.1"},
      {:phoenix_html, "~> 3.1"},
      {:phoenix_live_reload, "~> 1.3", only: [:dev, :local]},
      {:phoenix_live_view, "~> 0.17.10"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:contex, git: "https://github.com/mindok/contex"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
