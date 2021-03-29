defmodule TwitterTestTest do
  use ExUnit.Case

  doctest TwitterTest

  test "Connect to twitter" do
    IO.puts("trying to connect to twitter")
    assert TweetPuller.configure() == :ok
  end

end
