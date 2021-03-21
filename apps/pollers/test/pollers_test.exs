defmodule PollersTest do
  use ExUnit.Case
  doctest Pollers

  test "greets the world" do
    assert Pollers.hello() == :world
  end
end
