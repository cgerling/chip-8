defmodule Chip8.Interpreter.Instruction.SKNPTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SKNP
  alias Chip8.Interpreter.VRegisters

  describe "execute/2" do
    test "should return an interpreter with pc set to next instruction when key of vx is not pressed" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xF)
      v_registers = VRegisters.set(interpreter.v, x, x_value)
      interpreter = put_in(interpreter.v, v_registers)

      vx = %Register{value: x}
      arguments = {vx}
      executed_interpreter = SKNP.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc + 2 == executed_interpreter.pc
    end

    test "should return an interpreter with pc unchanged when key of vx is pressed" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xF)
      v_registers = VRegisters.set(interpreter.v, x, x_value)
      interpreter = put_in(interpreter.v, v_registers)
      interpreter = put_in(interpreter.keyboard.keys[x_value], :pressed)

      vx = %Register{value: x}
      arguments = {vx}
      executed_interpreter = SKNP.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc == executed_interpreter.pc
    end
  end
end
