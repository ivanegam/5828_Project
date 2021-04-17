defmodule CovidVaccines do
  @moduledoc """
  Provides functions for getting Our World in Data (OWID) global COVID-19 vaccination data
  using a remote CSV reader, and processing the retrieved data
  """

  @default_config Application.get_env(:covid_vaccines, :csv_reader)

  Application.ensure_all_started(:hackney)

  defmodule RemoteCSV do
    @moduledoc """
    Remote CSV reader, adapted from:
      https://blog.agilion.com/decoding-a-hosted-csv-file-in-elixir-7aa0bb3f7468
    """

    def stream(path) do
      Stream.resource(fn -> start_stream(path) end,
        &continue_stream/1,
        fn(_) -> :ok end)
    end

    defp start_stream(path) do
      {:ok, _status, _headers, ref} = :hackney.get(path, [], "")

      {ref, ""}
    end

    defp continue_stream(:halt), do: {:halt, []}

    defp continue_stream({ref, partial_row}) do
      case :hackney.stream_body(ref) do
        {:ok, data} ->
          data = partial_row <> data

          if ends_with_line_break?(data) do
            rows = split(data)

            {rows, {ref, ""}}
          else
            {rows, partial_row} = extract_partial_row(data)

            {rows, {ref, partial_row}}
          end

        :done ->
          if partial_row == "" do
            {:halt, []}
          else
            {[partial_row], :halt}
          end

        {:error, reason} ->
          raise reason
      end
    end

    defp extract_partial_row(data) do
      data = split(data)
      rows = Enum.drop(data, -1)
      partial = List.last(data)

      {rows, partial}
    end

    defp split(data), do: String.split(data, ~r/(\r?\n|\r)/, trim: true)

    defp ends_with_line_break?(data), do: String.match?(data, ~r/(\r?\n|\r)$/)
  end

  defp str_int(str) do
    case str do
      "" -> 0
      _ -> elem(Integer.parse(str),0)
    end
  end

  @doc """
  Processes a hosted CSV file retrieved by the CSV reader,
  Filtering by country (the U.S.),
  And getting the date and count of COVID-19 vaccinations
  """
  def process_covid_vaccines(config \\ @default_config) do
    config.fetch_vaccinations()
    |> Enum.map(fn {_, output} -> output end)
    |> Enum.filter(fn x -> x["iso_code"] == "USA" end)
    |> Enum.map(fn x -> {Date.from_iso8601!(x["date"]), str_int(x["daily_vaccinations"])} end)
    |> Enum.into(%{})

  end

  defmodule CSVReader do
    @moduledoc """
    Defines CSVReader behaviour, making sure the real and test CSV readers
    conform to the same interface
    """

    @callback fetch_vaccinations() :: list()
  end

  defmodule CSVReader.Reader do
    @moduledoc """
    Real CSV reader
    """

    @behaviour CSVReader

    @doc """
    Gets daily global COVID-19 vaccination data from the OWID API
    """
    @impl CSVReader
    def fetch_vaccinations() do
      url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv"

      RemoteCSV.stream(url)
      |> CSV.decode(headers: true)
      |> Enum.to_list
    end

  end

end
