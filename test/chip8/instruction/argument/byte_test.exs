defmodule Chip8.Instruction.Argument.ByteTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.Argument.Byte

  describe "new/1" do
    test "should return a Byte struct" do
      value = :rand.uniform(0xFF)

      byte = Byte.new(value)

      assert %Byte{} = byte
      assert byte.value == value
    end
  end

  describe "new/2" do
    test "should return a Byte struct" do
      byte = Byte.new(0x5, 0xE)

      assert %Byte{} = byte
      assert byte.value == 0x5E
    end
  end
end
