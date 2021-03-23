defmodule CovidCases do

  def fetch_cases(date) do

    %{body: body} = HTTPoison.get! cdc_url(date)

    decoded = Poison.decode! body

    statecases = Enum.map(decoded, fn (x) -> x["new_case"] end)

    statecasesNumeric = Enum.map(statecases, fn (x) -> (elem(Integer.parse(x),0)) end)

    Enum.sum(statecasesNumeric)

  end

  def cdc_url(date) do
    yy = date.year
         |> Integer.to_string
         |> String.pad_leading(4, "0")

    mm = date.month
         |> Integer.to_string
         |> String.pad_leading(2, "0")

    dd = date.day
         |> Integer.to_string
         |> String.pad_leading(2, "0")

    "https://data.cdc.gov/resource/9mfq-cb36.json?submission_date=" <> yy <> "-" <> mm <> "-" <> dd <> "T00:00:00.000"
  end

  defmodule DailyCases do

    @epistart ~D[2020-01-22]

    def daily() do

      dateDiff = Date.diff(Date.utc_today,@epistart)

      dates = Enum.map(0..dateDiff, &Date.add(@epistart, &1))

      dailyCases = Enum.reduce dates, %{}, fn x, acc ->
        Map.put(acc, x, CovidCases.fetch_cases(x))
      end

      dailyCases

    end
  end

  def hello do
    :world
  end
end
