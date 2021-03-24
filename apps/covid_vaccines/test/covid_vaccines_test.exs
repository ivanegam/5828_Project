defmodule CovidVaccinesTest do
  use ExUnit.Case
  doctest CovidVaccines

  test "vaccinations on feb 5 2021" do
    assert CovidVaccines.fetch_vaccinations()[~D[2021-02-05]] == 1615502
  end

end
