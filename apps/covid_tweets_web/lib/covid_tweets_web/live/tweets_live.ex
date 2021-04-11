defmodule CovidTweetsWeb.TweetsLive do
    use CovidTweetsWeb, :live_view
    use Timex
  
    import Ecto.Query, only: [from: 2]

    Application.ensure_all_started :timex
    @tz Timezone.get("America/Denver", Timex.now())

    # Get tweet data on initial page load
    def mount(_params, _session, socket) do
        socket =
          socket
          |> assign(:label, "covid")
          |> assign(:button_style_covid, "btn btn-primary")
          |> assign(:button_style_vaccine, "btn btn-secondary")
          |> assign(:tweets, get_tweets_yesterday(:covid_tweets))
          |> assign(:hashtags, get_hashtags_yesterday(:covid_tweets))
          |> assign(:yesterday, format_date(CovidDailyTweets.getYesterdayDenver()))

        {:ok, socket}
    end

    # Format datetime for the tweet display
    def format_datetime(d) do
        {:ok, formatted} =
        Timezone.convert(d, @tz)
        |> Timex.format("{Mshort} {D}, {YYYY}  {h12}:{m} {am}")
        
        formatted
    end

    # Format date for the tweet display
    def format_date(d) do
        {:ok, formatted} =
        Timezone.convert(d, @tz)
        |> Timex.format("{Mshort} {D}, {YYYY}")
        
        formatted
    end

    # Replace Twitter URLs with hyperlinks
    def format_links(text) do
        Regex.replace(~r/https?:\/\/t\.co\S*/, text, fn x -> "<a href=\"#{x}\">#{x}</a>" end)
    end

    # Get tweets from yesterday with a specific label
    def get_tweets_yesterday(label) do
        yesterday = CovidDailyTweets.getYesterdayDenver()
        tweet_query = from t in Data.Tweet,
                      where: t.label == ^label and fragment("?::date", t.time) == ^yesterday,
                      order_by: [desc: :time, desc: :retweet_count],
                      limit: 5
        
        tweet_query
        |> Data.Repo.all
        |> Enum.map(fn(tweet) -> %Data.Tweet{tweet | text: format_links(tweet.text)} end)
    end

    # Load "covid" tweets when the covid button is clicked
    def handle_event("covid", _value, socket) do 
        socket =
          socket
          |> assign(:label, "covid")
          |> assign(:button_style_covid, "btn btn-primary")
          |> assign(:button_style_vaccine, "btn btn-secondary")
          |> assign(:tweets, get_tweets_yesterday(:covid_tweets))
          |> assign(:hashtags, get_hashtags_yesterday(:covid_tweets))
          |> assign(:yesterday, format_date(CovidDailyTweets.getYesterdayDenver()))
    
        {:noreply, socket}
      end

    # Load "vaccine" tweets when the vaccine button is clicked
    def handle_event("vaccine", _value, socket) do 
        socket =
          socket
          |> assign(:label, "vaccine")
          |> assign(:button_style_covid, "btn btn-secondary")
          |> assign(:button_style_vaccine, "btn btn-primary")
          |> assign(:tweets, get_tweets_yesterday(:vaccine_tweets))
          |> assign(:hashtags, get_hashtags_yesterday(:vaccine_tweets))
          |> assign(:yesterday, format_date(CovidDailyTweets.getYesterdayDenver()))
    
        {:noreply, socket}
      end

    # Get hashtags from yesterday with a specific label
    def get_hashtags_yesterday(label) do
        yesterday = CovidDailyTweets.getYesterdayDenver()
        hashtag_query = from h in Data.Hashtag,
                        where: h.label == ^label and h.date == ^yesterday
        
        hashtag_query
        |> Data.Repo.one
    end

end