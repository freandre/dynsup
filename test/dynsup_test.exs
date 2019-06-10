defmodule DynsupTest do
  use ExUnit.Case
  doctest Dynsup

  test "greets the world" do
    assert Dynsup.hello() == :world
  end
end
