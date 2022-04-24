defmodule Chip8.Interpreter.Instruction.JPTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.JP
  alias Chip8.Interpreter.VRegisters

  describe "execute/2" do
    test "should return an interpreter with pc set to the given address" do
      interpreter = Interpreter.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_interpreter = JP.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert address.value == executed_interpreter.pc
    end

    test "should return an interpreter with pc set to the given address wrapped to 12 bits" do
      interpreter = Interpreter.new()

      value = :rand.uniform(0xFFF)
      address = %Address{value: 0xFFF + value}
      arguments = {address}
      executed_interpreter = JP.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert value - 1 == executed_interpreter.pc
    end

    test "should return an interpreter with pc set to the sum of v register 0 and the given address" do
      interpreter = Interpreter.new()
      register_value = :rand.uniform(0xFF)
      v_registers = VRegisters.set(interpreter.v, 0x0, register_value)
      interpreter = put_in(interpreter.v, v_registers)

      v0 = Register.v(0x0)
      address = %Address{value: :rand.uniform(0xFFF) - register_value}
      arguments = {v0, address}
      executed_interpreter = JP.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert register_value + address.value == executed_interpreter.pc
    end

    test "should return an interpreter with pc set to the sum of v register 0 and the given address wrapped to 12 bits" do
      interpreter = Interpreter.new()
      register_value = 0xF1F
      v_registers = VRegisters.set(interpreter.v, 0x0, register_value)
      interpreter = put_in(interpreter.v, v_registers)

      v0 = Register.v(0x0)
      address = %Address{value: 0x9E3}
      arguments = {v0, address}
      executed_interpreter = JP.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x902 == executed_interpreter.pc
    end
  end
end
