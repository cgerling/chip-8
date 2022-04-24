defmodule Chip8.Interpreter.Instruction.SNETest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SNE
  alias Chip8.Interpreter.VRegisters

  describe "execute/2" do
    test "should return an interpreter with pc unchanged when vx is equals to the given byte" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      v_registers = VRegisters.set(interpreter.v, x, byte)
      interpreter = put_in(interpreter.v, v_registers)

      vx = %Register{value: x}
      byte = %Byte{value: byte}
      arguments = {vx, byte}
      executed_interpreter = SNE.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc == executed_interpreter.pc
    end

    test "should return an interpreter with pc set to next instruction when vx is not equals to the given byte" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = 0x95
      v_registers = VRegisters.set(interpreter.v, x, x_value)
      interpreter = put_in(interpreter.v, v_registers)

      vx = %Register{value: x}
      byte = %Byte{value: 0xF2}
      arguments = {vx, byte}
      executed_interpreter = SNE.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc + 2 == executed_interpreter.pc
    end

    test "should return an interpreter with pc unchanged when vx is equals to vy" do
      interpreter = Interpreter.new()
      value = :rand.uniform(0xFF)
      x = 0x2
      y = 0x9
      v_registers = interpreter.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      interpreter = put_in(interpreter.v, v_registers)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SNE.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc == executed_interpreter.pc
    end

    test "should return an interpreter with pc set to next instruction when vx is not equals to vy" do
      interpreter = Interpreter.new()
      x = 0xE
      x_value = 0x95
      y = 0x3
      y_value = 0x10
      v_registers = interpreter.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      interpreter = put_in(interpreter.v, v_registers)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SNE.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc + 2 == executed_interpreter.pc
    end
  end
end
