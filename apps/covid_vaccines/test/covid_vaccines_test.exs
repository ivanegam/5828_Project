defmodule CovidVaccinesTest do
  use ExUnit.Case
  doctest CovidVaccines

  test "vaccinations on jan 22 2021" do
    assert CovidVaccines.fetch_vaccinations()[~D[2021-01-22]] == 975540
  end

end
