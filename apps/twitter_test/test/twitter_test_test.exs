defmodule TwitterTestTest do
  use ExUnit.Case
  doctest TwitterTest

  test "greets the world" do
    assert TwitterTest.hello() == :world
  end
end
