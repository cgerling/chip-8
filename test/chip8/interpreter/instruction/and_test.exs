defmodule Chip8.Instruction.ANDTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.AND
  alias Chip8.Interpreter.Instruction.Argument.Register

  describe "execute/2" do
    test "should return an interpreter with vx set to the result of a bitwise and of vx and vy" do
      interpreter = Interpreter.new()
      x = 0xB
      x_value = 0x43
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x4
      y_value = 0xC1
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = AND.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x41 == executed_interpreter.v[vx.value]
    end
  end
end
