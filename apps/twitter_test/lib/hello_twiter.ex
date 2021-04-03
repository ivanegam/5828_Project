
defmodule TweetPuller do

  ### Twitter tweet connect and pull


  def configure() do
    ExTwitter.configure(
      [consumer_key: "Insert key here",
      consumer_secret: "Insert key here",
      access_token: "Insert key here",
      access_token_secret: "Insert key here" ])
  end


  def getTweets() do
    stream = ExTwitter.stream_filter(track: ["#covid", "#vaccine"])
    for tweet <- stream do
      # TODO add tweet to DB
      # Placeholder
      IO.puts(tweet.text)
    end
    # Some times the stream will fail so loop to keep going
    getTweets()
  end

end

IO.puts(TweetPuller.configure())
TweetPuller.getTweets()
