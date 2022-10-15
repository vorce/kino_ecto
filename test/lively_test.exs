defmodule LivelyTest do
  use ExUnit.Case
  doctest Lively

  test "greets the world" do
    assert Lively.hello() == :world
  end
end
