Application.load(:covid_daily_tweets)

for app <- Application.spec(:covid_daily_tweets, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()
