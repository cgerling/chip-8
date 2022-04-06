defmodule Chip8.Runtime.Instruction.Argument.NibbleTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime.Instruction.Argument.Nibble

  describe "new/1" do
    test "should return a Nibble struct" do
      value = :rand.uniform(0xF)

      nibble = Nibble.new(value)

      assert %Nibble{} = nibble
      assert nibble.value == value
    end
  end
end
