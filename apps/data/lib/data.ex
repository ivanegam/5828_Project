defmodule Data do
  @moduledoc """
  Helper functions for inserting daily count, tweet, and hashtag data into the database
  """

  @doc """
  Inserts tweet data in the database
  """
  def insert_tweet(params) do
    changeset = Data.Tweet.changeset(%Data.Tweet{}, params)
    Data.Repo.insert(changeset)
  end

  @doc """
  Inserts daily count data in the database
  """
  def insert_daily_count(params) do
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, params)
    Data.Repo.insert(changeset)
  end


  @doc """
  Inserts a list of hashtags in the database
  """
  def insert_hashtags(params) do
    changeset = Data.Hashtag.changeset(%Data.Hashtag{}, params)
    Data.Repo.insert(changeset)
  end
end
