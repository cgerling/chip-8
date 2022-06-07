defmodule Chip8.Interpreter.Instruction.SHLTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SHL

  describe "execute/2" do
    test "should return an interpreter with v register F set to the most significant bit of vx" do
      interpreter = Interpreter.new()
      x = 0x0
      x_value = 0xF7
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      vy = %Register{value: 0x8}
      arguments = {vx, vy}
      executed_interpreter = SHL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.v[0xF] == 1
    end

    test "should return an interpreter with vx set to vx shifted one bit to the left" do
      interpreter = Interpreter.new()
      x = 0x5
      x_value = 0x45
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      vy = %Register{value: 0x9}
      arguments = {vx, vy}
      executed_interpreter = SHL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.v[vx.value] == 0x8A
    end

    test "should return an interpreter with vx set to vx shifted one bit to the left wrapped to 8 bits" do
      interpreter = Interpreter.new()
      x = 0x5
      x_value = 0xD5
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      vy = %Register{value: 0x9}
      arguments = {vx, vy}
      executed_interpreter = SHL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.v[vx.value] == 0xAA
    end
  end
end
