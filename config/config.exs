# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_keeb_ui,
  namespace: ElixirKeeb.UI

# Configures the endpoint
config :elixir_keeb_ui, ElixirKeeb.UIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lyJTNxBjfH08ODTgiErmNZZw4jsR9Cv8lNMtvUrYtJULavMR3envdyBF6l2SsrYv",
  render_errors: [view: ElixirKeeb.UIWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: ElixirKeeb.UI.PubSub,
  live_view: [signing_salt: "gqyVWgdq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
