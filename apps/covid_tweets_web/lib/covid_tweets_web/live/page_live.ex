defmodule CovidTweetsWeb.PageLive do
  use CovidTweetsWeb, :live_view
  import Ecto.Query, only: [from: 2]

  @first_day "2021-03-01"

  @impl true
  def mount(_params, _session, socket) do
    today = Date.utc_today() |> Date.to_string
    {:ok, assign(socket, first_day: @first_day, today: today)}
  end

  @impl true
  def handle_event("change_date_covid", %{"start_date" => start_date, "end_date" => end_date}, socket) do
    {tweet_dates, tweet_counts} = query_database(start_date, end_date, :covid_tweets)
    {covid_dates, covid_counts} = query_database(start_date, end_date, :covid_cases)

    if covid_dates != tweet_dates do
      raise "Data mismatch: at least one day only covid vases or twitter counts. This function requires that for each day either none or both have data."
    end  

    {:noreply, socket |> push_event("update_covid_chart", %{dates: tweet_dates, covid_counts: covid_counts, tweet_counts: tweet_counts})}
  end

  @impl true
  def handle_event("change_date_vaccine", %{"start_date" => start_date, "end_date" => end_date}, socket) do    
    {tweet_dates, tweet_counts} = query_database(start_date, end_date, :vaccine_tweets)
    {vaccine_dates, vaccine_counts} = query_database(start_date, end_date, :vaccine_counts)

    if vaccine_dates != tweet_dates do
      raise "Data mismatch: at least one day only vaccines counts or twitter counts. This function requires that for each day either none or both have data."
    end    

    {:noreply, socket |> push_event("update_vaccine_chart", %{dates: tweet_dates, vaccine_counts: vaccine_counts, tweet_counts: tweet_counts})}
  end

  def query_database(start_date, end_date, label) do
    # cast to Dates from strings
    {{_, start_date}, {_, end_date}} = {Date.from_iso8601(start_date), Date.from_iso8601(end_date)}
    # query database
    query = from dc in Data.DailyCount, 
      where: dc.date >= ^start_date and dc.date <= ^end_date and dc.label == ^label,
      select: %{date: dc.date, count: dc.count}
    results = query |> Data.Repo.all
    # Reduce results from list of maps to a list of dates and a list of counts
    dates = Enum.reduce(results, [], fn x, acc -> acc ++ [Date.to_string(x[:date])] end)
    counts = Enum.reduce(results, [], fn x, acc -> acc ++ [x[:count]] end)
    {dates, counts}
  end

end