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
    test "should return the value stored in the given register" do
      v_registers = VRegisters.new()

      register = :rand.uniform(0xF)
      value = VRegisters.get(v_registers, register)

      assert 0 == value
    end
  end

  describe "set/3" do
    test "should return a v registers struct with value stored in register at the given index" do
      v_registers = VRegisters.new()

      register = :rand.uniform(0xF)
      value = :rand.uniform(0xFF)

      setted_v_registers = VRegisters.set(v_registers, register, value)

      assert %VRegisters{} = setted_v_registers
      assert value == VRegisters.get(setted_v_registers, register)
    end
  end
end
