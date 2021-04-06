defmodule CovidCases do

  @default_config Application.get_env(:covid_cases, :cdc_api)

  def process_covid_cases(config \\ @default_config) do
    #Process JSON file fetched by the HTTP client

    {:ok, decoded} = config.get_cases()

    for %{"submission_date" => submission_date, "new_case" => new_case} <- decoded, reduce: %{} do
      acc -> Map.update(acc, Date.from_iso8601!(String.slice(submission_date,0,10)), elem(Integer.parse(new_case),0), & &1 + elem(Integer.parse(new_case),0))
    end

  end

  defmodule CDCAPI do
    #Define CDCAPI behaviour, making sure the real and test HTTP clients conform to the same interface

    @callback get_cases() :: {:ok, map()}
  end

  defmodule CDCAPI.HttpClient do
    #Real implementation of the HTTP client

    @behaviour CDCAPI

    @impl CDCAPI
    def get_cases() do
      url = "https://data.cdc.gov/resource/9mfq-cb36.json?$limit=1000000"

      HTTPoison.get!(url) |>
        Map.get(:body) |>
        Poison.decode()
    end

  end

end