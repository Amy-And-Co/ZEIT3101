import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :amyandco, Amyandco.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "amyandco_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :amyandco, AmyandcoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "YLdD85kP1I0uz2jjG9T5aBJ9YZy0O5Nvrzf13t26OVQn8NiCbZK0fUHCEIgtky5O",
  server: false

# In test we don't send emails.
config :amyandco, Amyandco.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime