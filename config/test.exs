import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :objective_challenge, ObjectiveChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "objective_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :objective_challenge, ObjectiveChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9bNTRb6E0qPRQjugd7cgqMbuFAyH3bTqPJG7CVmZ/rSiEm97fXb0tGRcoUUyxGIB",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
