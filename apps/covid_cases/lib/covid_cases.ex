defmodule CovidCases do

  def get_cases() do
    url = "https://data.cdc.gov/resource/9mfq-cb36.json?$limit=1000000"

    %{body: body} = HTTPoison.get! url

    decoded = Poison.decode! body

    for %{"submission_date" => submission_date, "new_case" => new_case} <- decoded, reduce: %{} do
      acc -> Map.update(acc, Date.from_iso8601!(String.slice(submission_date,0,10)), elem(Integer.parse(new_case),0), & &1 + elem(Integer.parse(new_case),0))
    end

  end

end
