defmodule Chip8.StackTest do
  use ExUnit.Case, async: true

  alias Chip8.Stack

  describe "new/0" do
    test "should return a stack struct" do
      stack = Stack.new()

      assert %Stack{} = stack
    end
  end
end
