defmodule CovidCasesTest do
  use ExUnit.Case
  doctest CovidCases

  import Mox

  @test_config Application.get_env(:covid_cases, :cdc_api)

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "process_covid_cases processes the values" do

    #Mock implementation of the HTTP client (the MockClient)
    #Config the MockClient to return a hardcoded set of values
    CovidCases.CDCAPI.MockClient
    |> expect(:get_cases, fn ->
      {:ok,
        [
          %{
            "conf_cases" => "5245.0",
            "conf_death" => "261.0",
            "consent_cases" => "Agree",
            "consent_deaths" => "Agree",
            "created_at" => "2020-05-05T17:25:08.000",
            "new_case" => "115.0",
            "new_death" => "8.0",
            "pnew_case" => "0",
            "pnew_death" => "0",
            "prob_cases" => "0",
            "prob_death" => "0",
            "state" => "ST1",
            "submission_date" => "2020-05-04T00:00:00.000",
            "tot_cases" => "5245",
            "tot_death" => "261"
          },
          %{
            "consent_cases" => "Not agree",
            "consent_deaths" => "Not agree",
            "created_at" => "2020-03-26T16:22:39.452",
            "new_case" => "23.0",
            "new_death" => "1.0",
            "state" => "ST1",
            "submission_date" => "2020-05-04T00:00:00.000",
            "tot_cases" => "101",
            "tot_death" => "1"
          },
          %{
            "conf_death" => "6380.0",
            "consent_cases" => "N/A",
            "consent_deaths" => "Agree",
            "created_at" => "2021-03-17T14:24:24.658",
            "new_case" => "708.0",
            "new_death" => "2.0",
            "pnew_case" => "152",
            "pnew_death" => "0",
            "prob_death" => "437",
            "state" => "ST2",
            "submission_date" => "2021-03-16T00:00:00.000",
            "tot_cases" => "498926",
            "tot_death" => "6817"
          }
        ]
      }
    end)

    assert CovidCases.process_covid_cases(@test_config) == %{~D[2020-05-04] => 115+23, ~D[2021-03-16] => 708}
  end

end