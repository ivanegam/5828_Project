defmodule CovidTweetsWeb.PullCountTest do
  use CovidTweetsWeb, :live_view
  import Ecto.Query, only: [from: 2]

  def get_dates_and_counts(start_date, end_date) do
    {{_, start_date}, {_, end_date}} = {Date.from_iso8601(start_date), Date.from_iso8601(end_date)}
    IO.puts(start_date)
    IO.puts(end_date)
    query = from dc in Data.DailyCount, 
      where: dc.date >= ^start_date and dc.date <= ^end_date,
      select: %{date: dc.date, count: dc.count}
    results = query |> Data.Repo.all
    IO.inspect(results)

    dates = Enum.reduce(results, [], fn x, acc -> acc ++ [x[:date]] end)
    counts = Enum.reduce(results, [], fn x, acc -> acc ++ [x[:count]] end)
    IO.inspect(dates)
  end

end


# CovidTweetsWeb.PullCountTest.get_dates_and_counts("2021-03-25", "2021-04-02")