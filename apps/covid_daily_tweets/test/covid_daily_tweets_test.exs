defmodule CovidDailyTweetsTest do
  use ExUnit.Case
  doctest CovidDailyTweets

  import Mox

  @test_config Application.get_env(:covid_daily_tweets, :twitter_api)

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "process_tweet_data processes the values" do

    # Make a sample timestamp for a tweet created yesterday (Denver time)
    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    {:ok, created_at_twitter} = Timex.format(created_at, "{WDshort} {Mshort} {0D} {h24}:{m}:{s} {Z} {YYYY}")

    #Mock implementation of the HTTP client (the MockClient)
    #Config the MockAPI to return a hardcoded set of values
    CovidDailyTweets.TwitterAPI.MockAPI
    |> expect(:getDailyTweets, fn _keyword ->
      [%{statuses:
         [%{created_at: created_at_twitter,
        user: %{name: "TestName",
                screen_name: "TestScreenName",
                profile_image_url_https: "https://abc.com/image.jpg"},
        text: "Sample tweet contents.",
        entities: %{hashtags: [%{text: "tag1"}, %{text: "tag2"}]},
        retweet_count: 0}]}]
    end)

  assert CovidDailyTweets.process_tweet_data("covid", @test_config) == [%{
    hashtags: ["tag1", "tag2"],
    label: :covid_tweets,
    name: "TestName",
    profile_image_url: "https://abc.com/image.jpg",
    retweet_count: 0,
    screen_name: "TestScreenName",
    text: "Sample tweet contents.",
    time: DateTime.shift_zone!(created_at, "America/Denver")}]
  end

  test "parses Twitter-provided timestamp correctly" do
    assert CovidDailyTweets.parseTime("Sun Feb 25 18:11:01 +0000 2018") |>
    DateTime.compare(~U[2018-02-25 18:11:01Z]) == :eq
  end

  test "gets most common hashtags" do
    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    tweet1 = %{
      hashtags: ["tag1", "tag2"],
      label: :covid_tweets,
      name: "TestName",
      profile_image_url: "https://abc.com/image.jpg",
      retweet_count: 0,
      screen_name: "TestScreenName",
      text: "Sample tweet contents.",
      time: created_at}

    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    tweet2 = %{
      hashtags: [],
      label: :covid_tweets,
      name: "TestName",
      profile_image_url: "https://abc.com/image.jpg",
      retweet_count: 0,
      screen_name: "TestScreenName",
      text: "Sample tweet contents.",
      time: created_at}

    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    tweet3 = %{
      hashtags: ["TaG2", "Tag1", "Tag3"],
      label: :covid_tweets,
      name: "TestName",
      profile_image_url: "https://abc.com/image.jpg",
      retweet_count: 0,
      screen_name: "TestScreenName",
      text: "Sample tweet contents.",
      time: created_at}

    {:ok, dateTimeDenver} = DateTime.shift_zone(created_at,"America/Denver")

    assert CovidDailyTweets.common_hashtags_yesterday([tweet1,tweet2,tweet3]) ==
      %{date: DateTime.to_date(dateTimeDenver), hashtags: ["#tag1 (2)", "#tag2 (2)"], label: :covid_tweets}
  end

  test "sorts tweets by most retweeted" do
    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    tweet1 = %{
      hashtags: ["tag1", "tag2"],
      label: :covid_tweets,
      name: "TestName",
      profile_image_url: "https://abc.com/image.jpg",
      retweet_count: 10,
      screen_name: "TestScreenName",
      text: "Sample tweet contents.",
      time: created_at}

    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    tweet2 = %{
      hashtags: [],
      label: :covid_tweets,
      name: "TestName",
      profile_image_url: "https://abc.com/image.jpg",
      retweet_count: 2,
      screen_name: "TestScreenName",
      text: "Sample tweet contents.",
      time: created_at}

    created_at = DateTime.add(DateTime.truncate(DateTime.utc_now,:second),-86400,:second)
    tweet3 = %{
      hashtags: ["TaG2", "Tag1", "Tag3"],
      label: :covid_tweets,
      name: "TestName",
      profile_image_url: "https://abc.com/image.jpg",
      retweet_count: 20,
      screen_name: "TestScreenName",
      text: "Sample tweet contents.",
      time: created_at}

    assert CovidDailyTweets.most_retweeted_yesterday([tweet1,tweet2,tweet3]) ==
    [tweet3, tweet1, tweet2]
  end
end