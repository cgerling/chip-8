defmodule Chip8.Interpreter.Instruction.SHRTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SHR

  describe "execute/2" do
    test "should return an interpreter with v register F set to the least significant bit of vx" do
      interpreter = Interpreter.new()
      x = 0x2
      x_value = 0x85
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      vy = %Register{value: 0xA}
      arguments = {vx, vy}
      executed_interpreter = SHR.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.v[0xF] == 1
    end

    test "should return an interpreter with vx set to vx shifted one bit to the right" do
      interpreter = Interpreter.new()
      x = 0x3
      x_value = 0xAD
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      vy = %Register{value: 0xC}
      arguments = {vx, vy}
      executed_interpreter = SHR.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.v[vx.value] == 0x56
    end
  end
end
