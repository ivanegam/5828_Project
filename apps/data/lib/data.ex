defmodule Data do
  @moduledoc """
  Helper functions for inserting data.
  """

  import Ecto.Query, only: [from: 2]

  # Maximum number of tweets per day to store in the database
  @max_tweets 5

  # Insert a new tweet, maintaining the maximum number of daily tweets allowed
  # in the database. If we have the maximum number stored, and the tweet's
  # retweet count is less than all of the existing tweets in the database,
  # the tweet is not inserted.
  def insert_tweet_rolling(params) do
    # Get number of tweets in DB that occurred on the date of the tweet we want to insert.
    tweet_date = DateTime.to_date(params.time)

    query_tweet_count = from t in Data.Tweet,
                        where: fragment("?::date", t.time) == ^tweet_date,
                        select: count(t.id)

    num_tweets = query_tweet_count |> Data.Repo.one

    if num_tweets < @max_tweets do
      # If there is space, insert the new tweet
      insert_tweet(params)
    else
      # We have the maximum daily tweets. Get the tweet with the fewest number of retweets
      query_fewest_retweets = from t in Data.Tweet,
                              where: fragment("?::date", t.time) == ^tweet_date,
                              order_by: [asc: :retweet_count],
                              limit: 1

      fewest_retweets =  query_fewest_retweets |> Data.Repo.one

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


  # Insert list of hashtags.
  def insert_hashtags(params) do
    changeset = Data.Hashtag.changeset(%Data.Hashtag{}, params)
    Data.Repo.insert(changeset)
  end
end
