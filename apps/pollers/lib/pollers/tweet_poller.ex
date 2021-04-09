defmodule Pollers.TweetPoller do
  use Task
  import Ecto.Query, only: [from: 2]

  @poll_milliseconds 3_600_000

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do

    yesterday = CovidDailyTweets.getYesterdayDenver()
    before_yesterday = Date.add(yesterday, -1)

    if findwork_tweets() do
      #If no tweet data for yesterday has been recorded, call the Twitter API and record it

        tweetdata_covid = CovidDailyTweets.metrics_yesterday("covid")
        tweetdata_vaccine = CovidDailyTweets.metrics_yesterday("vaccine")

        tweetcount_covid = tweetdata_covid.counts
        tweetcount_vaccine = tweetdata_vaccine.counts

        Data.insert_daily_count(%{date: yesterday, label: :covid_tweets, count: tweetcount_covid})
        Data.insert_daily_count(%{date: yesterday, label: :vaccine_tweets, count: tweetcount_vaccine})
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

  def findwork_tweets() do
    #Checks if there is tweet data for yesterday already recorded

    query = from c in Data.DailyCount,
                 select: c.date

    Data.Repo.all(query) |>
    Enum.member?(CovidDailyTweets.getYesterdayDenver()) |>
    Kernel.!
  end

  def findwork_covid_cases() do
    #Check if there is COVID-19 case data for day-before-yesterday already recorded

    query = from c in Data.DailyCount,
                 where: c.label == :covid_cases,
                 select: c.date

    Data.Repo.all(query) |>
      Enum.member?(Date.add(CovidDailyTweets.getYesterdayDenver(),-1))|>
      Kernel.!
  end

  def findwork_covid_vaccines() do
    #Check if there is COVID-19 vaccine data for day-before-yesterday already recorded

    query = from c in Data.DailyCount,
                 where: c.label == :vaccine_counts,
                 select: c.date

    Data.Repo.all(query) |>
      Enum.member?(Date.add(CovidDailyTweets.getYesterdayDenver(),-1))|>
      Kernel.!
  end
end