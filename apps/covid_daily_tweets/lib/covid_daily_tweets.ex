defmodule CovidDailyTweets do

    use Timex

    def configure() do
      ExTwitter.configure(
        [consumer_key: "9EXrt3HoqfOvMyBbEmN1MSG0D",
          consumer_secret: "HzTTqk40LZ1mzgi8sXNOtV3YVrst2Vm8JUSd4DdtDup0YRfeYo",
          access_token: "949636492040818688-otM3KBD7G9PsfWSufhO6pzRkAFh0V67",
          access_token_secret: "2kY8NZ3QawgR5aNmJJs7jNzxye08ipCNWTejJUgh8wi8c"])
    end

    def getDailyTweets(keyword) do
      #Fetch initial page of Twitter search results for a given keyword,
      #BY authors residing in, or tweeted FROM 10 miles within center of Boulder

      response = ExTwitter.search(keyword, [result_type: "recent", include_entities: true, count: 100, geocode: "40.015,-105.270556,10mi", search_metadata: true]) #|>

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
      #Parse timestamp provided by Twitter API

      Timex.parse!(timeStr, "%a %b %d %T %z %Y", :strftime)
    end

    def tweetdata_yesterday(keyword) do
      #Fetch tweet data for yesterday for a given keyword, from all pages of search results since "yesterday" may
      #span multiple pages

      configure()

      for x <- getDailyTweets(keyword) do
        x.statuses |>
          Enum.filter(fn x -> Date.diff(parseTime(x.created_at), Date.add(Date.utc_today,-1)) == 0 end) |>
          Enum.map(fn x -> {x.id_str, parseTime(x.created_at), x.user.screen_name, x.text, x.retweet_count, getHashtag(x), x.user.name, x.user.profile_image_url_https} end)
      end |>
        List.flatten()
    end

    def tweetcount_yesterday(keyword) do
      #Count of tweets containing a given keyword yesterday

      length(tweetdata_yesterday(keyword))
    end

    def common_hashtags_yesterday(keyword) do
      #Display hashtags associated with keyword-containing tweets from yesterday (exclude the obvious ones)

      tweetdata_yesterday(keyword) |>
        Enum.map(fn x -> elem(x,5) end) |>
        Enum.filter(fn x -> x != "" end) |>
        Enum.filter(fn x -> String.upcase(x) != String.upcase("vaccine") end) |>
        Enum.filter(fn x -> String.upcase(x) != String.upcase("vaccination") end) |>
        Enum.filter(fn x -> String.upcase(x) != String.upcase("covid") end) |>
        Enum.filter(fn x -> String.upcase(x) != String.upcase("covid19") end) |>
        Enum.filter(fn x -> String.upcase(x) != String.upcase("covidvaccine") end) |>
        Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>
        Enum.sort_by(&(elem(&1, 1)), :desc) |>
        Enum.map(fn x -> "#" <> elem(x,0) <> " " <> "(" <> to_string(elem(x, 1)) <> ")" end)
    end

    def most_retweeted_yesterday(keyword) do
      #Display most commonly retweeted keyword-containing tweets from yesterday

      tweetdata_yesterday(keyword) |>
        Enum.filter(fn x -> String.slice(elem(x,3), 0..3) != "RT @" end) |>
        Enum.sort_by(&(elem(&1, 4)), :desc) |>
        Enum.take(5)
    end

end
