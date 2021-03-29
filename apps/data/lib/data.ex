defmodule Data do
  @moduledoc """
  Documentation for `Data`.
  """

  import Ecto.Query, only: [from: 2]

  @max_tweets 5

  @query_tweet_count from t in Data.Tweet, select: count(t.id)
  
  @query_fewest_retweets from t in Data.Tweet, order_by: [asc: :retweet_count], limit: 1

  def insert_tweet_rolling(params) do
    # Get number of tweets in DB
    num_tweets =  @query_tweet_count |> Data.Repo.one

    if num_tweets < @max_tweets do
      # If there is space, add the new tweet
      insert_tweet(params)
    else
      # Table is full. Get the tweet with the fewest number of retweets
      fewest_retweets =  @query_fewest_retweets |> Data.Repo.one
      if fewest_retweets.retweet_count < params.retweet_count do
        # Delete the tweet with fewest retweets
        fewest_retweets |> Data.Repo.delete

        # Insert new tweet
        insert_tweet(params)
      else
        {:ok, params}
      end
    end
  end

  def insert_tweet(params) do
    changeset = Data.Tweet.changeset(%Data.Tweet{}, params)
    Data.Repo.insert(changeset)
  end

  def insert_daily_count(params) do
    changeset = Data.DailyCount.changeset(%Data.DailyCount{}, params)
    Data.Repo.insert(changeset)
  end
end
