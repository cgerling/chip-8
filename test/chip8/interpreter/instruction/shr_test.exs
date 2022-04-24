defmodule Chip8.Interpreter.Instruction.SHRTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SHR

  describe "execute/2" do
    test "should return an interpreter with v register F set to the least significant bit of vy" do
      interpreter = Interpreter.new()
      y = 0x2
      y_value = 0x85
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: 0xA}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SHR.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 1 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with vx set to vy shifted one bit to the right" do
      interpreter = Interpreter.new()
      y = 0x3
      y_value = 0xAD
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: 0xC}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SHR.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x56 == executed_interpreter.v[vx.value]
    end
  end
end
