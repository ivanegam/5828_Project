defmodule DataAnalysisTest do
  use ExUnit.Case
  doctest DataAnalysis

  test "positive sentiment" do
    assert DataAnalysis.get_sentiment("This is good.") > 0
  end

  test "neutral sentiment" do
    assert DataAnalysis.get_sentiment("This is okay.") == 0
  end

  test "negative sentiment" do
    assert DataAnalysis.get_sentiment("This is terrible.") < 0
  end
end
