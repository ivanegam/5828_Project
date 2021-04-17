defmodule CovidTweetsWeb.AcceptanceTest do
    use ExUnit.Case
    use Hound.Helpers
    import CovidTweetsWeb.Router.Helpers

    hound_session()

    @tweets_url tweets_url(CovidTweetsWeb.Endpoint, :index)
    @graphs_url page_url(CovidTweetsWeb.Endpoint, :index)

    setup_all do
        # Insert some data for testing
        insert_test_tweets()
        insert_hashtags()
        :ok
    end

    @tag :acceptance
    test "homepage loads and defaults to covid tweets", _meta do
        navigate_to(@tweets_url)
        :timer.sleep(2000)

        assert page_title() == "Covid Tweets"
        assert text_visible?("tweet-desc", ~r/Top tweets for covid/)
        assert text_visible?("hashtag-desc", ~r/Top hashtags associated with covid/)
    end

    @tag :acceptance
    test "graphs page loads", _meta do
        navigate_to(@graphs_url)
        :timer.sleep(2000)

        assert page_title() == "Covid Tweets"

        {status, _} = search_element(:id, "covid_chart")
        assert status == :ok

        {status, _} = search_element(:id, "vaccine_chart")
        assert status == :ok
    end

    @tag :acceptance
    test "covid button displays covid descriptions", _meta do
        navigate_to(@tweets_url)
        :timer.sleep(2000)

        find_element(:id, "covid-button")
            |> click()

        assert text_visible?("tweet-desc", ~r/Top tweets for covid/)
        assert text_visible?("hashtag-desc", ~r/Top hashtags associated with covid/)
    end

    @tag :acceptance
    test "vaccine button displays vaccine descriptions", _meta do
        navigate_to(@tweets_url)
        :timer.sleep(2000)

        find_element(:id, "vaccine-button")
            |> click()

        assert text_visible?("tweet-desc", ~r/Top tweets for vaccine/)
        assert text_visible?("hashtag-desc", ~r/Top hashtags associated with vaccine/)
    end

    @tag :acceptance
    test "covid button displays tweets and hashtags from database", _meta do
        navigate_to(@tweets_url)
        :timer.sleep(2000)

        find_element(:id, "covid-button")
            |> click()

        assert text_visible?("tweet-listing", ~r/This is a covid tweet\./)
        assert text_visible?("tweet-listing", ~r/Another covid tweet\./)
        assert text_visible?("hashtag-listing", ~r/#hashtag1 \(3\)/)
        assert text_visible?("hashtag-listing", ~r/#hashtag2 \(2\)/)
    end

    @tag :acceptance
    test "vaccine button displays tweets and hashtags from database", _meta do
        navigate_to(@tweets_url)
        :timer.sleep(2000)

        find_element(:id, "vaccine-button")
            |> click()

        assert text_visible?("tweet-listing", ~r/This is a vaccine tweet\./)
        assert text_visible?("tweet-listing", ~r/Another vaccine tweet\./)
        assert text_visible?("hashtag-listing", ~r/#hashtag3 \(6\)/)
        assert text_visible?("hashtag-listing", ~r/#hashtag4 \(5\)/)
    end

    @tag :acceptance
    test "graphs button loads graphs page", _meta do
        navigate_to(@tweets_url)
        :timer.sleep(2000)

        find_element(:id, "graphs-button")
            |> click()
        :timer.sleep(2000)

        # Graphs page should be loaded
        {status, _} = search_element(:id, "covid_chart")
        assert status == :ok

        {status, _} = search_element(:id, "vaccine_chart")
        assert status == :ok
    end

    @tag :acceptance
    test "tweets button loads homepage", _meta do
        navigate_to(@graphs_url)
        :timer.sleep(2000)

        find_element(:id, "tweets-button")
            |> click()
        :timer.sleep(2000)

        # Tweets homepage should be loaded
        assert text_visible?("tweet-desc", ~r/Top tweets for covid/)
        assert text_visible?("hashtag-desc", ~r/Top hashtags associated with covid/)
    end


    ########################################################
    # Helper Functions
    ########################################################
    
    # Check if text is visible in a page element. If not, retry after 10ms.
    # Code from https://adamdelong.com/test-asynchronous-text-changes-hound-phoenix/
    defp text_visible?(element_id, pattern, retries \\ 5)

    defp text_visible?(element_id, pattern, 0) do
        find_element(:id, element_id)
            |> visible_in_element?(pattern)
    end

    defp text_visible?(element_id, pattern, retries) do
        element = find_element(:id, element_id)
        case visible_in_element?(element, pattern) do
            true -> true

            false ->
            :timer.sleep(10)
            text_visible?(element_id, pattern, retries - 1)
        end
    end

    defp insert_test_tweets() do
        yesterday = CovidDailyTweets.getYesterdayDenver()
        {:ok, yesterday} = DateTime.new(yesterday, ~T[02:00:42Z], "America/Denver")
        {:ok, yesterday} = DateTime.shift_zone(yesterday, "Etc/UTC")

        tweet = %{
            time: yesterday,
            name: "Test User",
            screen_name: "TheTestUser",
            profile_image_url: "/images/twitter-logo-blue.png",
            text: "This is a covid tweet.",
            hashtags: ["#covid19", "#another"],
            retweet_count: 12,
            label: :covid_tweets,
            sentiment: -3
        }
        changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
        {:ok, _ret} = Data.Repo.insert(changeset)

        yesterday = CovidDailyTweets.getYesterdayDenver()
        {:ok, yesterday} = DateTime.new(yesterday, ~T[03:00:42Z], "America/Denver")
        {:ok, yesterday} = DateTime.shift_zone(yesterday, "Etc/UTC")
        
        tweet = %{
            time: yesterday,
            name: "Another User",
            screen_name: "AnotherUser",
            profile_image_url: "/images/twitter-logo-blue.png",
            text: "Another covid tweet.",
            hashtags: ["#covid19", "#another"],
            retweet_count: 10,
            label: :covid_tweets,
            sentiment: 2
        }
        changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
        {:ok, _ret} = Data.Repo.insert(changeset)

        tweet = %{
            time: yesterday,
            name: "Test User",
            screen_name: "TheTestUser",
            profile_image_url: "/images/twitter-logo-blue.png",
            text: "This is a vaccine tweet.",
            hashtags: ["#covid19", "#another"],
            retweet_count: 12,
            label: :vaccine_tweets,
            sentiment: -3
        }
        changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
        {:ok, _ret} = Data.Repo.insert(changeset)

        yesterday = CovidDailyTweets.getYesterdayDenver()
        {:ok, yesterday} = DateTime.new(yesterday, ~T[03:00:42Z], "America/Denver")
        {:ok, yesterday} = DateTime.shift_zone(yesterday, "Etc/UTC")
        
        tweet = %{
            time: yesterday,
            name: "Another User",
            screen_name: "AnotherUser",
            profile_image_url: "/images/twitter-logo-blue.png",
            text: "Another vaccine tweet.",
            hashtags: ["#covid19", "#another"],
            retweet_count: 10,
            label: :vaccine_tweets,
            sentiment: 2
        }
        changeset = Data.Tweet.changeset(%Data.Tweet{}, tweet)
        {:ok, _ret} = Data.Repo.insert(changeset)
    end

    defp insert_hashtags() do
        yesterday = CovidDailyTweets.getYesterdayDenver()

        hashtag = %{
            date: yesterday,
            hashtags: ["#hashtag1 (3)", "#hashtag2 (2)"],
            label: :covid_tweets
        }
        changeset = Data.Hashtag.changeset(%Data.Hashtag{}, hashtag)
        {:ok, _ret} = Data.Repo.insert(changeset)

        yesterday = CovidDailyTweets.getYesterdayDenver()

        hashtag = %{
            date: yesterday,
            hashtags: ["#hashtag3 (6)", "#hashtag4 (5)"],
            label: :vaccine_tweets
        }
        changeset = Data.Hashtag.changeset(%Data.Hashtag{}, hashtag)
        {:ok, _ret} = Data.Repo.insert(changeset)
    end

end