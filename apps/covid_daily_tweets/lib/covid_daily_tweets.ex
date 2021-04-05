defmodule CovidDailyTweets do

    use Timex

    def configure() do
      ExTwitter.configure(
        [consumer_key: "",
          consumer_secret: "",
          access_token: "",
          access_token_secret: ""])
    end

    def getYesterdayDenver() do
      #Get yesterday's date (Denver time)

      {:ok, nowDenver} = DateTime.shift_zone(DateTime.utc_now, "America/Denver")
      todayDenver = DateTime.to_date(nowDenver)
      Date.add(todayDenver,-1)
    end

    def getDailyTweets(keyword) do
      configure()

      #Fetch initial page of Twitter search results for a given keyword,
      #Excluding retweets,
      #BY authors residing IN, or tweeted FROM 80-mi radius of Denver,
      #Since yesterday (UTC)

      response = ExTwitter.search(keyword, [result_type: "recent", include_entities: true, count: 100, search_metadata: true, geocode: "39.7642548,-104.9951964,80mi", exclude: "retweets", since: Date.to_iso8601(getYesterdayDenver())])

      #Append remaining pages of search results, if any
      cond do
        Map.has_key?(response.metadata, :next_results) ->
          getNext(response)
        true ->
          [response]
      end
    end

    def getNext(response) do
      #Recursively append remaining pages of search results

      next = ExTwitter.search_next_page(response.metadata)

      cond do
        Map.has_key?(next.metadata, :next_results) ->
          [next] ++ getNext(next)
        true ->
          [next]
      end
    end

    def getHashtag(hashtags) do
      hashtags |>
      Enum.map(fn x -> x.text end)
    end

    def parseTime(timeStr) do
      #Parse tweet timestamp provided by Twitter API, convert to Denver timezone

      {:ok, dateTime} = Timex.parse(timeStr, "%a %b %d %T %z %Y", :strftime)

      {:ok, dateTimeDenver} = DateTime.shift_zone(dateTime, "America/Denver")

      dateTimeDenver
    end

    def dateTimeIsYesterday(dateTime) do
      #Check if a datetime (in Denver time) is yesterday (in Denver time)

      Date.compare(DateTime.to_date(dateTime), getYesterdayDenver()) == :eq
    end

    def tweetdata_yesterday(keyword) do
      #Fetch tweet data for yesterday (UTC) for a given keyword,
      #from all pages of search results since "yesterday" may span multiple pages,
      #further filter to "yesterday" relative to Denver time

      for x <- getDailyTweets(keyword) do
        x.statuses |>
          Enum.filter(fn x -> dateTimeIsYesterday(parseTime(x.created_at)) end) |>
          Enum.map(fn x -> %{time: parseTime(x.created_at), name: x.user.name, screen_name: x.user.screen_name, profile_image_url: x.user.profile_image_url_https, text: x.text, hashtags: getHashtag(x.entities.hashtags), retweet_count: x.retweet_count} end)
      end |>
        List.flatten()
    end

    def tweetcount_yesterday(tweetdata) do
      #Get tweet count from tweet data

      length(tweetdata)
    end

    def common_hashtags_yesterday(tweetdata) do
      #Get hashtags from tweet data

      excludedHashtags = ["", "VACCINE", "VACCINATION", "COVID", "COVID19", "COVID_19", "COVIDVACCINE", "CORONAVIRUS"]

      tweetdata |>
        Enum.map(fn x -> x.hashtags end) |>
        List.flatten() |>
        Enum.map(fn x -> String.downcase(x) end) |>
        Enum.filter(fn x -> !Enum.member?(excludedHashtags,String.upcase(x)) end) |>
        Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>
        Enum.filter(fn {_k, v} -> v > 1 end) |>
        Enum.sort_by(&elem(&1, 1), :desc) |>
        Enum.map(fn x -> "#" <> elem(x,0) <> " " <> "(" <> to_string(elem(x, 1)) <> ")" end)
    end

    def most_retweeted_yesterday(tweetdata) do
      #Get most retweeted tweets from tweet data

      tweetdata |>
        Enum.sort_by(fn(tweet) -> tweet.retweet_count end, :desc) |>
        Enum.take(5)
    end

    def metrics_yesterday(keyword) do
      #Fetch all metrics for a keyword together to avoid multiple calls

      tweetdata = tweetdata_yesterday(keyword)

      %{counts: tweetcount_yesterday(tweetdata), hashtags: common_hashtags_yesterday(tweetdata), retweeteds: most_retweeted_yesterday(tweetdata)}
    end

end
