defmodule CovidTweetsWeb.TweetCountTestDataGenerator do
  # Create data to test graphing of tweet counts
  import Ecto.Query, only: [from: 2]


  defmodule MatchedData do
    def add_count(date, n) do
      # Covid tweet count insertion
      count = round(:math.cos(n / :math.pi) * 1000 + 1000)
      covid_count = %{
        date: Date.add(date, n),
        label: :covid_tweets,
        count: count
      }
      changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
      {:ok, _} = Data.Repo.insert(changeset)

      # Covid case count insertion
      count = round(:math.sin(n / :math.pi) * 100 + 100)
      covid_count = %{
        date: Date.add(date, n),
        label: :covid_cases,
        count: count
      }
      changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
      {:ok, _} = Data.Repo.insert(changeset)

      # Vaccine Tweet count insertion
      count = round(:math.cos(n / :math.pi) * 500 + 500)
      covid_count = %{
        date: Date.add(date, n),
        label: :vaccine_tweets,
        count: count
      }
      changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
      {:ok, _} = Data.Repo.insert(changeset)

      # Vaccine count insertion
      count = round(:math.sin(n / :math.pi) * 50 + 50)
      covid_count = %{
        date: Date.add(date, n),
        label: :vaccine_counts,
        count: count
      }
      changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
      {:ok, _} = Data.Repo.insert(changeset)
    end

    def add_count_loop(date, n) when n == 100 do
      add_count(date, n)
    end

    def add_count_loop(date, n) do
      add_count(date, n)
      add_count_loop(date, n+1)
    end
  end

  defmodule MismatchedData do
    def add_count(date, n) do
      if rem(n, 4) == 0 do
        # Covid tweet count insertion
        count = round(:math.cos(n / :math.pi) * 1000 + 1000)
        covid_count = %{
          date: Date.add(date, n),
          label: :covid_tweets,
          count: count
        }
        changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
        {:ok, _} = Data.Repo.insert(changeset)
      end

      if rem(n, 4) == 1 do
        # Covid case count insertion
        count = round(:math.sin(n / :math.pi) * 100 + 100)
        covid_count = %{
          date: Date.add(date, n),
          label: :covid_cases,
          count: count
        }
        changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
        {:ok, _} = Data.Repo.insert(changeset)
      end

      if rem(n, 4) == 2 do
        # Vaccine Tweet count insertion
        count = round(:math.cos(n / :math.pi) * 500 + 500)
        covid_count = %{
          date: Date.add(date, n),
          label: :vaccine_tweets,
          count: count
        }
        changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
        {:ok, _} = Data.Repo.insert(changeset)
      end

      if rem(n, 4) == 3 do
        # Vaccine count insertion
        count = round(:math.sin(n / :math.pi) * 50 + 50)
        covid_count = %{
          date: Date.add(date, n),
          label: :vaccine_counts,
          count: count
        }
        changeset = Data.DailyCount.changeset(%Data.DailyCount{}, covid_count)
        {:ok, _} = Data.Repo.insert(changeset)
      end
    end

    def add_count_loop(date, n) when n == 100 do
      add_count(date, n)
    end

    def add_count_loop(date, n) do
      add_count(date, n)
      add_count_loop(date, n+1)
    end
  end

  def generate_matched() do
    MatchedData.add_count_loop(Date.from_iso8601("2021-03-01") |> elem(1), 0)
  end

  def generate_mismatched() do
    MismatchedData.add_count_loop(Date.from_iso8601("2021-03-01") |> elem(1), 0)
  end
end

# To use this script, first call `iex -S mix` then:
# CovidTweetsWeb.TweetCountTestDataGenerator.generate_matched()
# OR
# CovidTweetsWeb.TweetCountTestDataGenerator.generate_mismatched()