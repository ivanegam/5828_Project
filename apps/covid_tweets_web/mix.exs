defmodule CovidTweetsWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :covid_tweets_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      preferred_cli_env: ["test.acceptance": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {CovidTweetsWeb.Application, []},
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
      {:phoenix, "~> 1.5.3"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phoenix_live_view, "~> 0.15.4"},
      {:floki, ">= 0.27.0", only: :test},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:messaging, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:timex, "~> 3.0"},
      {:data, in_umbrella: true}, # depends on the Data app for persistence
      {:covid_daily_tweets, in_umbrella: true},
      {:appsignal_phoenix, "~> 2.0.0"},
      {:hound, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: [
        "deps.get",
        "cmd npm install --prefix assets"
      ],

      test: [
        "ecto.drop --repo Data.Repo --quiet",
        "ecto.create --repo Data.Repo --quiet",
        "ecto.migrate --repo Data.Repo ",
        "test --no-start --exclude acceptance"
      ],

      "test.acceptance": [
        "ecto.drop --repo Data.Repo --quiet",
        "ecto.create --repo Data.Repo --quiet",
        "ecto.migrate --repo Data.Repo",
        "test --no-start --only acceptance"]
    ]
  end
end
