defmodule Pollers.TweetPoller do
  use Task

  @poll_milliseconds 86_400_000

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    receive do
    after
      @poll_milliseconds ->
        get_tweets()
        poll()
    end
  end

  defp get_tweets() do
    # TODO Here we will call the Twitter API and add tweets
    # to the database. For now, as an example, I am just
    # creating a tweet from scratch.

    # Create a tweet
    tweet = %Data.Tweet{
      location: "Denver, Colorado",
      time: DateTime.truncate(DateTime.utc_now, :second),
      content: "Blah Blah Blah",
      hashtags: ["#covid19", "#vaccine"]
    }

    # Use a changeset to validate the tweet object
    changeset = Data.Tweet.changeset(tweet, %{})

    # Insert into database
    case Data.Repo.insert(changeset) do
      {:ok, _tweet} ->
        IO.puts "Successfully added a tweet"
      {:error, changeset} ->
        IO.puts "Error inserting tweet"
        for e <- changeset.errors do
          IO.puts e
        end
    end
  end

end