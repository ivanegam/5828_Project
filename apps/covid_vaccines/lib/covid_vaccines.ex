defmodule CovidVaccines do

  ### Source for fetching a hosted CSV file: https://blog.agilion.com/decoding-a-hosted-csv-file-in-elixir-7aa0bb3f7468

  Application.ensure_all_started(:hackney)

  defmodule RemoteCSV do
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

  def fetch_vaccinations do
    url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/country_data/United%20States.csv"

    RemoteCSV.stream(url)
    |> CSV.decode(headers: true)
    |> Enum.to_list
    |> Enum.map(fn {_, output} -> output end)
    |> Enum.map(fn x -> {Date.from_iso8601!(x["date"]), elem(Integer.parse(x["total_vaccinations"]),0)} end)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x, y] -> {elem(y,0), elem(y,1)-elem(x,1)} end)
    |> Enum.into(%{})
  end

end
