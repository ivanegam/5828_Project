defmodule DataTweetTest do
  use ExUnit.Case
  use Data.RepoCase
  import Ecto.Query, only: [from: 2]
  doctest Data

  test "insert and retrieve a tweet" do
    # Create tweet
    tweet = %{
      time: ~U[2021-01-01 02:00:42Z],
      name: "Test User",
      screen_name: "TheTestUser",
      profile_image_url: "https://www.testdomain.com/image.png",
      text: "Test tweet.",
      hashtags: ["#covid19", "#another"],
      retweet_count: 12,
      label: :covid_tweets,
      sentiment: 0
    }

    # Insert tweet
    changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
    {:ok, ret} = Data.Repo.insert(changeset)
    
    assert ret.time == tweet.time
    assert ret.name == tweet.name
    assert ret.screen_name == tweet.screen_name
    assert ret.profile_image_url == tweet.profile_image_url
    assert ret.text == tweet.text
    assert ret.hashtags == tweet.hashtags
    assert ret.retweet_count == tweet.retweet_count
    assert ret.label == tweet.label
    assert ret.sentiment == tweet.sentiment

    # Retrieve tweet
    query = from t in Data.Tweet,
            where: t.time == ^tweet.time and t.screen_name == ^tweet.screen_name

    q_tweet =
      query
      |> Data.Repo.one
    
      assert q_tweet.time == tweet.time
      assert q_tweet.name == tweet.name
      assert q_tweet.screen_name == tweet.screen_name
      assert q_tweet.profile_image_url == tweet.profile_image_url
      assert q_tweet.text == tweet.text
      assert q_tweet.hashtags == tweet.hashtags
      assert q_tweet.retweet_count == tweet.retweet_count
      assert q_tweet.label == tweet.label
      assert q_tweet.sentiment == tweet.sentiment
  end

  test "error on inserting tweet with missing data" do
    # Create tweet
    tweet = %{
      time: ~U[2021-01-01 02:00:42Z],
      name: "Test User",
      screen_name: "TheTestUser",
      profile_image_url: "https://www.testdomain.com/image.png",
      # Missing text
      hashtags: ["#covid19", "#another"],
      retweet_count: 12,
      label: :covid_tweets,
      sentiment: -1
    }

    # Insert tweet
    changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
    {status, _ret} = Data.Repo.insert(changeset)
    assert status == :error
  end

  test "error on inserting tweet with sentiment to low" do
    # Create tweet
    tweet = %{
      time: ~U[2021-01-01 02:00:42Z],
      name: "Test User",
      screen_name: "TheTestUser",
      profile_image_url: "https://www.testdomain.com/image.png",
      text: "Test tweet.",
      hashtags: ["#covid19", "#another"],
      retweet_count: 12,
      label: :covid_tweets,
      sentiment: -6
    }

    # Insert tweet
    changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
    {status, _ret} = Data.Repo.insert(changeset)
    assert status == :error
  end

  test "error on inserting tweet with sentiment to high" do
    # Create tweet
    tweet = %{
      time: ~U[2021-01-01 02:00:42Z],
      name: "Test User",
      screen_name: "TheTestUser",
      profile_image_url: "https://www.testdomain.com/image.png",
      text: "Test tweet.",
      hashtags: ["#covid19", "#another"],
      retweet_count: 12,
      label: :covid_tweets,
      sentiment: 6
    }

    # Insert tweet
    changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
    {status, _ret} = Data.Repo.insert(changeset)
    assert status == :error
  end

end
