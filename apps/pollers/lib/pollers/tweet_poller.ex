defmodule Pollers.TweetPoller do
  use Task

  @poll_milliseconds 60_000

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    get_tweets()
    receive do
    after
      @poll_milliseconds ->
        poll()
    end
  end

  defp get_tweets() do
    # TODO Here we will call the Twitter API and add tweets
    # to the database. For now, as an example, I am just
    # creating a tweet from scratch.

    # Create a tweet
    retweets = Enum.random(0..1000)
    text = "This was retweeted #{retweets} times"
    tweet = %{
      time: DateTime.truncate(DateTime.utc_now, :second),
      name: "Bob Jones",
      screen_name: "therealbobjones",
      profile_image_url: "https://pbs.twimg.com/profile_images/1307830840169299969/ax10eQV__normal.jpg",
      text: text,
      hashtags: ["#covid19", "#vaccine"],
      retweet_count: retweets
    }

    # Insert into database
    case Data.insert_tweet_rolling(tweet) do
      {:ok, _tweet} ->
        IO.puts "Successfully processed tweet"
      {:error, changeset} ->
        IO.puts "Error inserting tweet"
        for e <- changeset.errors do
          IO.puts e
        end
    end
  end

end