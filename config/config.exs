# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :objective_challenge,
  ecto_repos: [ObjectiveChallenge.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configure your database
config :objective_challenge, ObjectiveChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "objective_challenge_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binery_id]

# Configures the endpoint
config :objective_challenge, ObjectiveChallengeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: ObjectiveChallengeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ObjectiveChallenge.PubSub,
  live_view: [signing_salt: "Yv7qjoEW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
