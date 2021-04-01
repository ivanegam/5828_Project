defmodule CovidDailyTweets do

    use Timex

    def configure() do
      ExTwitter.configure(
        [consumer_key: "",
          consumer_secret: "",
          access_token: "",
          access_token_secret: ""])
    end

    def getDailyTweets(keyword) do
      #Fetch initial page of Twitter search results for a given keyword,
      #Excluding retweets,
      #BY authors residing IN, or tweeted FROM 80-mi radius of Denver

      response = ExTwitter.search(keyword, [result_type: "recent", include_entities: true, count: 100, search_metadata: true, geocode: "39.7642548,-104.9951964,80mi", exclude: "retweets"])

      #Append other pages of search results, as many as available

      getNext(response) |>
        Enum.drop(-3)
    end

    def getNext(response) when is_nil(response) do
      [nil]
    end

    def getNext(response) do
      #Get next page of search results, until nil

      next = ExTwitter.search_next_page(response.metadata)

      [next] ++ getNext(next)
    end

    def getHashtag(statuses) do
      # Get first hashtag associated with a tweet. If no hashtags, return ""

      cond do
        statuses.entities.hashtags == [] -> ""
        true -> Enum.fetch!(statuses.entities.hashtags,0).text
      end
    end

    def parseTime(timeStr) do
      #Parse tweet timestamp provided by Twitter API, convert to Denver timezone

      dateTime = Timex.parse!(timeStr, "%a %b %d %T %z %Y", :strftime)

      {:ok, dateTimeDenver} = DateTime.shift_zone(dateTime, "America/Denver")

      dateTimeDenver
    end

    def dateTimeIsYesterday(dateTime) do
      #Check if a datetime (in Denver time) is yesterday (in Denver time)

      {:ok, nowDenver} = DateTime.shift_zone(DateTime.utc_now, "America/Denver")

      todayDenver = DateTime.to_date(nowDenver)

      yesterdayDenver = Date.add(todayDenver,-1)

      DateTime.to_date(dateTime) == yesterdayDenver
    end

    def tweetdata_yesterday(keyword) do
      #Fetch tweet data for yesterday for a given keyword, from all pages of search results since "yesterday" may
      #span multiple pages

      configure()

      for x <- getDailyTweets(keyword) do
        x.statuses |>
          Enum.filter(fn x -> dateTimeIsYesterday(parseTime(x.created_at)) end) |>
          Enum.map(fn x -> {x.id_str, parseTime(x.created_at), x.user.screen_name, x.text, x.retweet_count, getHashtag(x), x.user.name, x.user.profile_image_url_https} end)
      end |>
        List.flatten()
    end

    def tweetcount_yesterday(tweetdata) do
      #Get tweet count from tweet data

      length(tweetdata)
    end

    def common_hashtags_yesterday(tweetdata) do
      #Get hashtags from tweet data

      excludedHashtags = ["", "VACCINE", "VACCINATION", "COVID", "COVID19", "COVID_19", "COVIDVACCINE"]

      tweetdata |>
        Enum.map(fn x -> elem(x,5) end) |>
        Enum.filter(fn x -> !Enum.member?(excludedHashtags,String.upcase(x)) end) |>
        Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>
        Enum.sort_by(&(elem(&1, 1)), :desc) |>
        Enum.map(fn x -> "#" <> elem(x,0) <> " " <> "(" <> to_string(elem(x, 1)) <> ")" end)
    end

    def most_retweeted_yesterday(tweetdata) do
      #Get most retweeted tweets from tweet data

      tweetdata |>
        #Enum.filter(fn x -> String.slice(elem(x,3), 0..3) != "RT @" end) |>
        Enum.sort_by(&(elem(&1, 4)), :desc) |>
        Enum.take(5)
    end

    def metrics_yesterday(keyword) do
      #Fetch all metrics for a keyword together to avoid multiple calls

      tweetdata = tweetdata_yesterday(keyword)

      %{counts: tweetcount_yesterday(tweetdata), hashtags: common_hashtags_yesterday(tweetdata), retweeteds: most_retweeted_yesterday(tweetdata)}
    end

end
