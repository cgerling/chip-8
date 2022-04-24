defmodule Chip8.Interpreter.Instruction.XORTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.XOR

  describe "execute/2" do
    test "should return an interpreter with vx set to the result of a bitwise xor of vx and vy" do
      interpreter = Interpreter.new()
      x = 0x1
      x_value = 0x7F
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x7
      y_value = 0x44
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = XOR.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x3B == executed_interpreter.v[vx.value]
    end
  end
end
