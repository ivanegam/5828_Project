Application.load(:covid_tweets)

for app <- Application.spec(:covid_tweets, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()
