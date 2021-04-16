# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :covid_tweets_web,
  generators: [context_app: :covid_tweets]

# Configures the endpoint
config :covid_tweets_web, CovidTweetsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4DyAFwK3Hy2QmYYbR02yH78PyZwwkG+4pH1wyhY9TxavZgGtHd/sTaE+oNfjB7KS",
  render_errors: [view: CovidTweetsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CovidTweets.PubSub,
  live_view: [signing_salt: "Vvbk3XMd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :data, ecto_repos: [Data.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

#Config for timezone database
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

#Config for the real HTTP client
config :covid_cases, :cdc_api, CovidCases.CDCAPI.HttpClient

#Config for the real CSV reader
config :covid_vaccines, :csv_reader, CovidVaccines.CSVReader.Reader

#Config for test Twitter API
config :covid_daily_tweets, :twitter_api, CovidDailyTweets.TwitterAPI.API