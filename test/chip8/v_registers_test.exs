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

  describe "fetch/2" do
    test "should return a tagged tuple with the value stored in the given register" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(v_registers, register, register_value)

      value = VRegisters.fetch(v_registers, register)

      assert {:ok, register_value} == value
    end

    test "should return the value stored in the given register when using Access.fetch/2" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(v_registers, register, register_value)

      value = Access.fetch(v_registers, register)

      assert {:ok, register_value} == value
    end

    test "should return the value stored in the given register when using brackets notation" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(v_registers, register, register_value)

      value = v_registers[register]

      assert register_value == value
    end
  end

  describe "get_and_update/3" do
    test "should return a tuple with the given function return value and the v registers with the given register updated" do
      v_registers = VRegisters.new()

      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      update_function = fn _ -> {:get_value, register_value} end

      result = VRegisters.get_and_update(v_registers, register, update_function)

      assert {get_value, updated_v_registers} = result
      assert :get_value == get_value
      assert register_value == VRegisters.get(updated_v_registers, register)
    end

    test "should return a tuple with the given function return value and the v registers with the given register updated when using Access.get_and_update/3" do
      v_registers = VRegisters.new()

      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      update_function = fn _ -> {:get_value, register_value} end

      result = Access.get_and_update(v_registers, register, update_function)

      assert {get_value, updated_v_registers} = result
      assert :get_value == get_value
      assert register_value == VRegisters.get(updated_v_registers, register)
    end

    test "should return a tuple with the current value of the given register and the v registers with the given register cleared" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(v_registers, register, register_value)

      update_function = fn _ -> :pop end

      result = VRegisters.get_and_update(v_registers, register, update_function)

      assert {current_value, updated_v_registers} = result
      assert register_value == current_value
      assert 0 == VRegisters.get(updated_v_registers, register)
    end

    test "should raise when the given function return value is invalid" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      update_function = fn value -> value end

      message = "the given function must return a two-element tuple or :pop, got: 0"

      assert_raise RuntimeError, message, fn ->
        VRegisters.get_and_update(v_registers, register, update_function)
      end
    end
  end

  describe "pop/2" do
    test "should return a tuple with the value of the register and the v registers with the given register cleared" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(v_registers, register, register_value)

      result = VRegisters.pop(v_registers, register)

      assert {current_value, updated_v_registers} = result
      assert register_value == current_value
      assert 0 == VRegisters.get(updated_v_registers, register)
    end

    test "should return a tuple with the value of the register and the v registers with the given register cleared when using Access.pop/2" do
      v_registers = VRegisters.new()
      register = :rand.uniform(0xF)
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(v_registers, register, register_value)

      result = Access.pop(v_registers, register)

      assert {current_value, updated_v_registers} = result
      assert register_value == current_value
      assert 0 == VRegisters.get(updated_v_registers, register)
    end

    test "should return a tuple with a value and the given v registers when the given register is not present" do
      v_registers = VRegisters.new()

      out_of_range_register = 0xF + :rand.uniform(0xF) + 1
      result = VRegisters.pop(v_registers, out_of_range_register)

      assert {0, v_registers} == result
    end

    test "should return a tuple with a empty value and the given v registers when the given register is not valid" do
      v_registers = VRegisters.new()

      invalid_register = :invalid_register
      result = VRegisters.pop(v_registers, invalid_register)

      assert {0, v_registers} == result
    end
  end
end
