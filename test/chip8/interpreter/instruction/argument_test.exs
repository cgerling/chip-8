defmodule Chip8.Interpreter.Instruction.ArgumentTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Instruction.Argument

  require Chip8.Interpreter.Instruction.Argument

  describe "is_nibble/1" do
    test "should return true when value is integer and between 0x0 and 0xF" do
      value = :rand.uniform(0xF)

      assert Argument.is_nibble(value)
    end

    test "should return false when value is not an integer" do
      for invalid_value <- [0.0, %{}, {}, [], ""] do
        refute Argument.is_nibble(invalid_value)
      end
    end

    test "should return false when value is negative" do
      negative_number = -:rand.uniform(0xF)

      refute Argument.is_nibble(negative_number)
    end

    test "should return false when value is larger then 0xF" do
      large_integer = :rand.uniform(0xF) + 0x10

      refute Argument.is_nibble(large_integer)
    end
  end
end
