defmodule CovidDailyTweets do
  @moduledoc """
  Provides functions for calling the Twitter API and processing the retrieved data
  """

    use Timex
    @default_config Application.get_env(:covid_daily_tweets, :twitter_api)

    @doc """
    Configure the authentication data for the Twitter API
    """
    def configure() do
      ExTwitter.configure(
        [consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
          consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
          access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
          access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")])
    end

    @doc """
    Gets yesterday's date (Denver time)
    """
    def getYesterdayDenver() do
      {:ok, nowDenver} = DateTime.shift_zone(DateTime.utc_now, "America/Denver")
      todayDenver = DateTime.to_date(nowDenver)
      Date.add(todayDenver,-1)
    end

    @doc """
    Processes tweet data retrieved from from the Twitter API,
    filtering by yesterday's date (Denver time),
    and extracting entities of interest (e.g., tweet text)
    """
    def process_tweet_data(keyword, config \\ @default_config) do


      tweet_data = config.getDailyTweets(keyword)

      for x <- tweet_data do
        x.statuses |>
          Enum.filter(fn x -> dateTimeIsYesterday(parseTime(x.created_at)) end) |>
          Enum.map(fn x -> %{time: parseTime(x.created_at), name: x.user.name, screen_name: x.user.screen_name, profile_image_url: x.user.profile_image_url_https, text: x.text, hashtags: getHashtag(x.entities.hashtags), retweet_count: x.retweet_count, label: String.to_atom(keyword <> "_tweets")} end)
      end |>
        List.flatten()
    end

    defmodule TwitterAPI do
      @moduledoc """
      #Defines TwitterAPI behaviour, making sure the real and test clients
      conform to the same interface
      """

      @callback getDailyTweets(keyword) :: list()
    end

    defmodule TwitterAPI.API do
      @moduledoc """
      Real implementation of the Twitter API
      """

      @behaviour TwitterAPI

      @doc """
      Retrieves initial page of Twitter search results for a given keyword,
      excluding retweets,
      BY authors residing IN, or tweeted FROM 80-mi radius of Denver,
      since yesterday (UTC),
      In English
      """
      @impl TwitterAPI
      def getDailyTweets(keyword) do
        CovidDailyTweets.configure()

        response = ExTwitter.search(keyword, [result_type: "recent", include_entities: true, count: 100, search_metadata: true, geocode: "39.7642548,-104.9951964,80mi", exclude: "retweets", since: Date.to_iso8601(CovidDailyTweets.getYesterdayDenver()), lang: "en"])

        #Append remaining pages of search results, if any
        cond do
          Map.has_key?(response.metadata, :next_results) ->
            CovidDailyTweets.getNext(response)
          true ->
            [response]
        end
      end
    end

    @doc """
    Recursively appends remaining pages of search results to those found by getDailyTweets/1
    """
    def getNext(response) do
      next = ExTwitter.search_next_page(response.metadata)

      cond do
        Map.has_key?(next.metadata, :next_results) ->
          [next] ++ getNext(next)
        true ->
          [next]
      end
    end

    @doc """
    Maps tweet hashtags to a list
    """
    def getHashtag(hashtags) do
      hashtags |>
      Enum.map(fn x -> x.text end)
    end

    @doc """
    Parses the tweet timestamp provided by Twitter API,
    and converts to the Denver timezone
    """
    def parseTime(timeStr) do
      {:ok, dateTime} = Timex.parse(timeStr, "%a %b %d %T %z %Y", :strftime)

      {:ok, dateTimeDenver} = DateTime.shift_zone(dateTime, "America/Denver")

      dateTimeDenver
    end

    @doc """
    Checks if a datetime is yesterday (in Denver time)
    """
    def dateTimeIsYesterday(dateTime) do
      Date.compare(DateTime.to_date(dateTime), getYesterdayDenver()) == :eq
    end

    @doc """
    Gets tweet count from tweet data
    """
    def tweetcount_yesterday(tweetdata) do
      count = length(tweetdata)

      %{date: getYesterdayDenver(), count: count, label: List.first(tweetdata).label}
    end

    @doc """
    Get mosts common hashtags from tweet data,
    excluding trivial ones
    """
    def common_hashtags_yesterday(tweetdata) do
      excludedHashtags = ["", "VACCINE", "VACCINATION", "COVID", "COVID19", "COVID_19", "COVIDVACCINE", "CORONAVIRUS"]

      hashtags = tweetdata |>
        Enum.map(fn x -> x.hashtags end) |>
        List.flatten() |>
        Enum.map(fn x -> String.downcase(x) end) |>
        Enum.filter(fn x -> !Enum.member?(excludedHashtags,String.upcase(x)) end) |>
        Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>
        Enum.filter(fn {_k, v} -> v > 1 end) |>
        Enum.sort_by(&elem(&1, 1), :desc) |>
        Enum.map(fn x -> "#" <> elem(x,0) <> " " <> "(" <> to_string(elem(x, 1)) <> ")" end)

        %{date: getYesterdayDenver(), hashtags: hashtags, label: List.first(tweetdata).label}
    end

    @doc """
    Gets most retweeted tweets from tweet data
    """
    def most_retweeted_yesterday(tweetdata) do
      tweetdata |>
        Enum.sort_by(fn(tweet) -> tweet.retweet_count end, :desc) |>
        Enum.take(5)
    end

    @doc """
    Calculates all metrics of interest for a given keyword together to avoid multiple calls:
      - Total tweet counts
      - Most common hashtags
      - Most retweeted tweets
    """
    def metrics_yesterday(keyword) do
    tweetdata = process_tweet_data(keyword)

      %{counts: tweetcount_yesterday(tweetdata), hashtags: common_hashtags_yesterday(tweetdata), retweeteds: most_retweeted_yesterday(tweetdata)}
    end

end
