defmodule Data do
  @moduledoc """
  Helper functions for inserting data.
  """
  
  # Insert a tweet.
  def insert_tweet(params) do
    changeset = Data.Tweet.changeset(%Data.Tweet{}, params)
    Data.Repo.insert(changeset)
  end

  # Insert a daily count.
  def insert_daily_count(params) do
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, params)
    Data.Repo.insert(changeset)
  end
end
