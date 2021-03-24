defmodule CovidCasesTest do
  use ExUnit.Case
  doctest CovidCases

  test "cases on jan 21 2021" do
    assert CovidCases.get_cases[~D[2021-01-21]] == 189633
  end

end
