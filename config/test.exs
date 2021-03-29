use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :covid_tweets_web, CovidTweetsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :data, Data.Repo,
  database: "data_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
