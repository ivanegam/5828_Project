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
  def handle_event("change_date", %{"start_date" => start_date, "end_date" => end_date}, socket) do
    IO.inspect(start_date)
    # cast to Dates from strings
    {{_, start_date}, {_, end_date}} = {Date.from_iso8601(start_date), Date.from_iso8601(end_date)}
    # query database
    query = from dc in Data.DailyCount, 
      where: dc.date >= ^start_date and dc.date <= ^end_date,
      select: %{date: dc.date, count: dc.count}
    results = query |> Data.Repo.all
    # Reduce results from list of maps to a list of dates and a list of counts
    dates = Enum.reduce(results, [], fn x, acc -> acc ++ [Date.to_string(x[:date])] end)
    counts = Enum.reduce(results, [], fn x, acc -> acc ++ [x[:count]] end)

    {:noreply, socket |> push_event("update_covid_chart", %{dates: dates, counts: counts})}
  end


end