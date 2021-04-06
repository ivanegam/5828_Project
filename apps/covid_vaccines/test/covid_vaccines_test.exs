defmodule CovidVaccinesTest do

  use ExUnit.Case
  doctest CovidVaccines

  import Mox

  @test_config Application.get_env(:covid_vaccines, :csv_reader)

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "process_covid_vaccines processes the values" do

    #Mock implementation of the CSV reader (the MockReader)
    #Config the MockReader to return a hardcoded set of values
    CovidVaccines.CSVReader.MockReader
    |> expect(:fetch_vaccinations, fn ->
      [ok: %{"daily_vaccinations" => "173922",
        "daily_vaccinations_per_million" => "126",
        "daily_vaccinations_raw" => "237050",
        "date" => "2021-01-21",
        "iso_code" => "IND",
        "location" => "India",
        "people_fully_vaccinated" => "",
        "people_fully_vaccinated_per_hundred" => "0.08",
        "people_vaccinated" => "1043534",
        "people_vaccinated_per_hundred" => "0.08",
        "total_vaccinations" => "1043534",
        "total_vaccinations_per_hundred" => "0.08"
      },ok: %{"daily_vaccinations" => "1355451",
        "daily_vaccinations_per_million" => "4053",
        "daily_vaccinations_raw" => "1099103",
        "date" => "2021-02-01",  "iso_code" => "USA",
        "location" => "United States",
        "people_fully_vaccinated" => "5927847",
        "people_fully_vaccinated_per_hundred" => "1.77",
        "people_vaccinated" => "26023153",
        "people_vaccinated_per_hundred" => "7.78",
        "total_vaccinations" => "32222402",
        "total_vaccinations_per_hundred" => "9.63"}]
    end )

    assert CovidVaccines.process_covid_vaccines(@test_config) == %{~D[2021-02-01] => 1355451}
  end

end