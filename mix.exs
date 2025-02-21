defmodule CovidTweets.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      apps: [:covid_cases, :covid_daily_tweets, :messaging, :covid_tweets_web, :covid_vaccines, :data, :data_analysis, :pollers],
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: ["test.acceptance": :test]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    [
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"],
      
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test --no-start --exclude acceptance"
      ],

      "test.acceptance": [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test --no-start --only acceptance"
      ]
    ]
  end
end
