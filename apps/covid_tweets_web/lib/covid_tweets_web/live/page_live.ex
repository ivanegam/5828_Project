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
    # cast to Dates from strings
    {{_, start_date}, {_, end_date}} = {Date.from_iso8601(start_date), Date.from_iso8601(end_date)}
    {tweet_dates, tweet_counts} = query_database(start_date, end_date, :covid_tweets)
    {covid_dates, covid_counts} = query_database(start_date, end_date, :covid_cases)

    if covid_dates != tweet_dates do
      raise "Data mismatch: at least one day only covid vases or twitter counts. This function requires that for each day either none or both have data."
    end  

    {:noreply, socket |> push_event("update_covid_chart", %{dates: tweet_dates, covid_counts: covid_counts, tweet_counts: tweet_counts})}
  end

  @impl true
  def handle_event("change_date_vaccine", %{"start_date" => start_date, "end_date" => end_date}, socket) do
    # cast to Dates from strings
    {{_, start_date}, {_, end_date}} = {Date.from_iso8601(start_date), Date.from_iso8601(end_date)} 
    {tweet_dates, tweet_counts} = query_database(start_date, end_date, :vaccine_tweets)
    {vaccine_dates, vaccine_counts} = query_database(start_date, end_date, :vaccine_counts)

    tweet_dates = Enum.map(tweet_dates, fn x -> Date.from_iso8601(x) |> elem(1) end)
    vaccine_dates = Enum.map(vaccine_dates, fn x -> Date.from_iso8601(x) |> elem(1) end)
    full_date_set = Enum.map(0..Date.diff(end_date, start_date), &Date.add(start_date, &1))

    IO.inspect(vaccine_counts)

    {vaccine_dates, vaccine_counts} = if length(full_date_set) > length(vaccine_dates) do
      # IO.inspect("Data mismatch #{length(full_date_set)} > #{length(vaccine_dates)}: attempting to fix...")
      {vaccine_dates, vaccine_counts} = fix_data_mismatch(vaccine_dates, vaccine_counts, full_date_set, 0)
      # if length(full_date_set) != length(vaccine_counts) do
      #   IO.inspect("Data mismatch unresolved: #{length(full_date_set)} != #{length(vaccine_counts)}")
      #   raise "Data mismatch: unable to be fixed"
      # else
      #   IO.inspect("Data mismatch resolved: #{length(full_date_set)} == #{length(vaccine_counts)}")
      # end
      else
        {vaccine_dates, vaccine_counts}
    end

    {tweet_dates, tweet_counts} = if length(full_date_set) > length(tweet_dates) do
      # IO.inspect("Data mismatch #{length(full_date_set)} > #{length(tweet_dates)}: attempting to fix...")
      {tweet_dates, tweet_counts} = fix_data_mismatch(tweet_dates, tweet_counts, full_date_set, 0)
      # if length(full_date_set) != length(tweet_counts) do
      #   IO.inspect("Data mismatch unresolved: #{length(full_date_set)} != #{length(tweet_counts)}")
      #   raise "Data mismatch: unable to be fixed"
      # else
      #   IO.inspect("Data mismatch resolved: #{length(full_date_set)} == #{length(tweet_counts)}")
      # end
      else
        {tweet_dates, tweet_counts}
    end


    # IO.inspect("????")
    # IO.inspect(tweet_dates)
    # IO.inspect(vaccine_dates)
    # IO.inspect(full_date_set)

    {:noreply, socket |> push_event("update_vaccine_chart", %{dates: full_date_set, vaccine_counts: vaccine_counts, tweet_counts: tweet_counts})}
  end

  def query_database(start_date, end_date, label) do
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

  def fix_data_mismatch(dates, data, all_dates, index) do
    
    cond do
      # Base case
      length(dates) == length(all_dates) ->
        {dates, data}
      # Missing dates at the end of the list
      index >= length(dates) and index < length(all_dates)->
        {dates, data} = insert_missing(dates, data, all_dates, index)
        {dates, data} = fix_data_mismatch(dates, data, all_dates, index)
      # Missing a data point. Fill in a date/data
      Date.compare(Enum.at(dates, index), Enum.at(all_dates, index)) == :gt ->
        {dates, data} = insert_missing(dates, data, all_dates, index)
        {dates, data} = fix_data_mismatch(dates, data, all_dates, index)
      # Dates lines up, do nothing and move on to next index
      Date.compare(Enum.at(dates, index), Enum.at(all_dates, index)) == :eq ->
        {dates, data} = fix_data_mismatch(dates, data, all_dates, index + 1)
      # true -> 
      #   IO.inspect("All dates: #{Enum.at(all_dates, index)}, fetched datese: #{Enum.at(dates, index)}")
      #   raise "no conda is true"
    end
  end

  def insert_missing(dates_to_fill, data_to_fill, all_dates, index) do
    # IO.inspect("input dates:")
    # IO.inspect(dates_to_fill)
    # IO.inspect(data_to_fill)
    dates_filled = List.insert_at(dates_to_fill, index, Enum.at(all_dates, index))
    # Zero fill
    data_filled = data_filled = List.insert_at(data_to_fill, index, 0)
    # interpolate
    if False do
      val = 0
      if index > 0 and index < length(data_to_fill) do
        val = div(Enum.at(data_to_fill, index - 1) + Enum.at(data_to_fill, index), 2)
      end
      data_filled = List.insert_at(data_to_fill, index, val)
    end
    # IO.inspect("output")
    # IO.inspect(dates_filled)
    # IO.inspect(data_filled)
    {dates_filled, data_filled}
  end



end