defmodule CovidDailyTweetsTest do
  use ExUnit.Case
  doctest CovidDailyTweets

  test "greets the world" do
    assert CovidDailyTweets.hello() == :world
  end
end
