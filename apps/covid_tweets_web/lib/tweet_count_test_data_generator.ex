defmodule CovidTweetsWeb.TweetCountTestDataGenerator do
  # Create data to test graphing of tweet counts
  import Ecto.Query, only: [from: 2]


  defmodule AddCounts do
    def add_count(date, n) do
      count = round(:math.cos(n / :math.pi) * 1000 + 1000)
      daily_count = %{
        date: Date.add(date, n),
        label: :covid_tweets,
        count: count
      }
      changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count)
      {:ok, ret} = Data.Repo.insert(changeset)
    end

    def add_count_loop(date, n) when n == 100 do
      add_count(date, n)
    end

    def add_count_loop(date, n) do
      add_count(date, n)
      add_count_loop(date, n+1)
    end
  end

  def generate() do
    AddCounts.add_count_loop(Date.from_iso8601("2021-03-01") |> elem(1), 0)
  end
end