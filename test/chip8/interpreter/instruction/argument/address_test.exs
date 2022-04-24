defmodule Chip8.Interpreter.Instruction.Argument.AddressTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Instruction.Argument.Address

  describe "new/1" do
    test "should return a Address struct" do
      value = :rand.uniform(0x8C2)

      address = Address.new(value)

      assert %Address{} = address
      assert address.value == value
    end
  end

  describe "new/3" do
    test "should return a Address struct" do
      address = Address.new(0xF, 0x0, 0x6)

      assert %Address{} = address
      assert address.value == 0xF06
    end
  end
end
