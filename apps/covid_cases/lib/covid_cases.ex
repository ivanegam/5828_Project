defmodule CovidCases do
  @moduledoc """
  Provides functions for calling the Data.CDC.Gov API using an HTTP client and
  processing the retrieved COVID-19 data;
  """

  @default_config Application.get_env(:covid_cases, :cdc_api)

  @doc """
  Gets the date of incidence and the number of incident cases from the retrieved COVID-19 data;
  Aggregates the data from the state to the national level.
  """
  def process_covid_cases(config \\ @default_config) do
    #Process JSON file fetched by the HTTP client

    {:ok, decoded} = config.get_cases()

    for %{"submission_date" => submission_date, "new_case" => new_case} <- decoded, reduce: %{} do
      acc -> Map.update(acc, Date.from_iso8601!(String.slice(submission_date,0,10)), elem(Integer.parse(new_case),0), & &1 + elem(Integer.parse(new_case),0))
    end

  end

  defmodule CDCAPI do
    @moduledoc """
    Defines CDCAPI behaviour, making sure the real and test HTTP clients conform to the same interface
    """

    @callback get_cases() :: {:ok, map()}
  end

  defmodule CDCAPI.HttpClient do
    @moduledoc """
    Real implementation of the HTTP client
    """

    @behaviour CDCAPI

    @doc """
    Submit GET request to the Data.CDC.gov API to retrieve daily state-level COVID-19 data
    """
    @impl CDCAPI
    def get_cases() do
      url = "https://data.cdc.gov/resource/9mfq-cb36.json?$limit=1000000"

      HTTPoison.get!(url) |>
        Map.get(:body) |>
        Poison.decode()
    end

  end

end