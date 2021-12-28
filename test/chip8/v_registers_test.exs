defmodule Chip8.VRegistersTest do
  use ExUnit.Case, async: true

  alias Chip8.VRegisters

  describe "new/0" do
    test "should return a v registers struct" do
      v_registers = VRegisters.new()

      assert %VRegisters{} = v_registers
    end
  end

  describe "get/2" do
    test "should return an integer" do
      v_registers = VRegisters.new()

      register = :rand.uniform(0xF)
      value = VRegisters.get(v_registers, register)

      assert is_integer(value)
    end

    test "should return the value stored in the given register" do
      v_registers = VRegisters.new()

      register = :rand.uniform(0xF)
      value = VRegisters.get(v_registers, register)

      assert 0 == value
    end
  end
end
