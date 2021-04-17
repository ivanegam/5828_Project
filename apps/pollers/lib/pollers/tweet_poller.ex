defmodule Pollers.TweetPoller do
  @moduledoc """
  Poller for periodically checking the database for the presence of
  the latest available data
  """

  use Task
  import Ecto.Query, only: [from: 2]

  @poll_milliseconds 3_600_000

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  @doc """
  Checks if there is any work to be done for retrieving and inserting
  daily count, tweet, and hashtag data;
  if so, calls the Twitter/Data.CDC.gov/OWID APIs and
  inserts the data into the database
  """
  def poll() do

    yesterday = CovidDailyTweets.getYesterdayDenver()
    before_yesterday = Date.add(yesterday, -1)

    if findwork_tweets() do
      #If no tweet data for yesterday has been recorded, call the Twitter API and record it

        tweetdata_covid = CovidDailyTweets.metrics_yesterday("covid")
        tweetdata_vaccine = CovidDailyTweets.metrics_yesterday("vaccine")

        tweetcount_covid = tweetdata_covid.counts
        tweetcount_vaccine = tweetdata_vaccine.counts

        toptweets_covid =
          tweetdata_covid.retweeteds
          |> Enum.map(fn(tweet) -> Map.put(tweet, :sentiment, DataAnalysis.get_sentiment(tweet.text)) end)
        
        toptweets_vaccine =
          tweetdata_vaccine.retweeteds
          |> Enum.map(fn(tweet) -> Map.put(tweet, :sentiment, DataAnalysis.get_sentiment(tweet.text)) end)

        hashtags_covid = tweetdata_covid.hashtags
        hashtags_vaccine = tweetdata_vaccine.hashtags

        #Insert tweets counts
        Data.insert_daily_count(tweetcount_covid)
        Data.insert_daily_count(tweetcount_vaccine)

        #Insert top tweets
        Enum.each(toptweets_covid, fn (tweet) -> Data.insert_tweet(tweet) end)
        Enum.each(toptweets_vaccine, fn (tweet) -> Data.insert_tweet(tweet) end)

        #Insert top hashtags
        Data.insert_hashtags(hashtags_covid)
        Data.insert_hashtags(hashtags_vaccine)
    end

    if findwork_covid_cases() do
      #If no case data for day-before-yesterday has been recorded, call the Data.CDC.gov API and record it

      covid_case_data = CovidCases.process_covid_cases()

      case_count = covid_case_data[before_yesterday]

      Data.insert_daily_count(%{date: before_yesterday, label: :covid_cases, count: case_count})
     end

    if findwork_covid_vaccines() do
      #If no vaccine data for day-before-yesterday has been recorded, call the OWID API and record it

      vaccine_data = CovidVaccines.process_covid_vaccines()

      vaccine_count = vaccine_data[before_yesterday]

      Data.insert_daily_count(%{date: before_yesterday, label: :vaccine_counts, count: vaccine_count})
    end

    receive do
    after
      @poll_milliseconds ->
        poll()
    end
  end

  @doc """
  Checks if there is tweet data for yesterday already in the database
  """
  def findwork_tweets() do
    query = from c in Data.Tweet,
                 select: c.time

    Data.Repo.all(query) |>
      Enum.map(fn t -> DateTime.shift_zone(t, "America/Denver") end) |>
      Enum.map(fn({:ok, t}) -> DateTime.to_date(t) end) |>
      Enum.member?(CovidDailyTweets.getYesterdayDenver()) |>
      Kernel.!
  end

  @doc """
  Checks if there is COVID-19 case data for day-before-yesterday already in the databasee
  """
  def findwork_covid_cases() do
    query = from c in Data.DailyCount,
                 where: c.label == :covid_cases,
                 select: c.date

    Data.Repo.all(query) |>
      Enum.member?(Date.add(CovidDailyTweets.getYesterdayDenver(),-1))|>
      Kernel.!
  end

  @doc """
  Checks if there is COVID-19 vaccine data for day-before-yesterday already in the database
  """
  def findwork_covid_vaccines() do

    query = from c in Data.DailyCount,
                 where: c.label == :vaccine_counts,
                 select: c.date

    Data.Repo.all(query) |>
      Enum.member?(Date.add(CovidDailyTweets.getYesterdayDenver(),-1))|>
      Kernel.!
  end
end