defmodule Chip8.Interpreter.Instruction.ORTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.OR
  alias Chip8.Interpreter.VRegisters

  describe "execute/2" do
    test "should return an interpreter with vx set to the result of a bitwise or of vx and vy" do
      interpreter = Interpreter.new()
      x = 0xC
      x_value = 0xD1
      y = 0xA
      y_value = 0x85
      v_registers = interpreter.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      interpreter = put_in(interpreter.v, v_registers)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = OR.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0xD5 == executed_interpreter.v[vx.value]
    end
  end
end
