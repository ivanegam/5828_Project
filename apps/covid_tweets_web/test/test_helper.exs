Application.load(:covid_tweets_web)
Application.ensure_all_started(:covid_tweets_web)
for app <- Application.spec(:covid_tweets_web, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Data.Repo, :manual)