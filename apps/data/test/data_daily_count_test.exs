defmodule DataDailyCountTest do
  use ExUnit.Case
  use Data.RepoCase
  import Ecto.Query, only: [from: 2]
  doctest Data

  test "insert and retrieve a covid tweet daily count" do
    # Create daily count
    daily_count = %{
      date: ~D[2021-01-01],
      label: :covid_tweets,
      count: 123
    }

    # Insert daily count
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count)
    {:ok, ret} = Data.Repo.insert(changeset)
    
    assert ret.date == ~D[2021-01-01]
    assert ret.label == :covid_tweets
    assert ret.count == 123

    # Retrieve daily count
    query = from dc in Data.DailyCount,
            where: dc.date == ^~D[2021-01-01] and dc.label == :covid_tweets

    q_daily_count =
      query
      |> Data.Repo.one
    
    assert q_daily_count.date == ~D[2021-01-01]
    assert q_daily_count.label == :covid_tweets
    assert q_daily_count.count == 123
  end

  test "error on inserting a duplicate daily count" do
    # Create daily count
    daily_count_1 = %{
      date: ~D[2021-01-01],
      label: :covid_cases,
      count: 14
    }

    # Insert daily count
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count_1)
    {:ok, _ret} = Data.Repo.insert(changeset)

    # Create daily count
    daily_count_2 = %{
      date: ~D[2021-01-01],
      label: :covid_cases,
      count: 42
    }

    # Insert daily count
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count_2)
    {status, _ret} = Data.Repo.insert(changeset)
    
    assert status == :error
  end

  test "error on inserting daily count with missing data" do
    # Create daily count
    daily_count = %{
      date: ~D[2021-01-01],
      label: :vaccines_counts,
      # Missing count
    }

    # Insert daily count
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count)
    {status, _ret} = Data.Repo.insert(changeset)
    assert status == :error
  end

  test "error on inserting daily count with invalid label" do
    # Create daily count
    daily_count = %{
      date: ~D[2021-01-01],
      label: :invalid_label,
      count: 12
    }

    # Insert daily count
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count)
    {status, _ret} = Data.Repo.insert(changeset)
    assert status == :error
  end

  test "error on inserting daily count less than zero" do
    # Create daily count
    daily_count = %{
      date: ~D[2021-01-01],
      label: :covid_cases,
      count: -1
    }

    # Insert daily count
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count)
    {status, _ret} = Data.Repo.insert(changeset)
    assert status == :error
  end

  test "insert real COVID-19 case data" do
    # Create daily counts

    case_data = CovidCases.process_covid_cases()

    today = Date.utc_today
    tomorrow = Date.add(today,1)

    daily_count_1 = %{
      date: ~D[2021-01-01],
      label: :covid_cases,
      count: case_data[~D[2021-01-01]]
    }

    daily_count_2 = %{
      date: tomorrow,
      label: :covid_cases,
      count: case_data[tomorrow]
    }

    # Insert daily count from a past date
    changeset1 = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count_1)
    {status1, _ret} = Data.Repo.insert(changeset1)

    #Insert daily count from tomorrow
    changeset2 = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count_2)
    {status2, _ret} = Data.Repo.insert(changeset2)

    #Inserting a past date's data should be OK
    assert status1 == :ok

    #Inserting tomorrow's (i.e. nonexistent) data should give an error
    assert status2 == :error
  end

  test "insert real COVID-19 vaccine data" do
    # Create daily counts

    vaccine_data = CovidVaccines.process_covid_vaccines()

    today = Date.utc_today
    tomorrow = Date.add(today,1)

    daily_count_1 = %{
      date: ~D[2021-01-01],
      label: :covid_cases,
      count: vaccine_data[~D[2021-01-01]]
    }

    daily_count_2 = %{
      date: tomorrow,
      label: :covid_cases,
      count: vaccine_data[tomorrow]
    }

    # Insert daily count from a past date
    changeset1 = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count_1)
    {status1, _ret} = Data.Repo.insert(changeset1)

    #Insert daily count from tomorrow
    changeset2 = Data.DailyCount.changeset(%Data.DailyCount{}, daily_count_2)
    {status2, _ret} = Data.Repo.insert(changeset2)

    #Inserting a past date's data should be OK
    assert status1 == :ok

    #Inserting tomorrow's (i.e. nonexistent) data should give an error
    assert status2 == :error
  end
end
