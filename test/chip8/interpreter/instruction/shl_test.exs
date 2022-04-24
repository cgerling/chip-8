defmodule Chip8.Interpreter.Instruction.SHLTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SHL

  describe "execute/2" do
    test "should return an interpreter with v register F set to the most significant bit of vy" do
      interpreter = Interpreter.new()
      y = 0x0
      y_value = 0xF7
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: 0x8}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SHL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 1 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with vx set to vy shifted one bit to the left" do
      interpreter = Interpreter.new()
      y = 0x5
      y_value = 0x45
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: 0x9}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SHL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x8A == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to vy shifted one bit to the left wrapped to 8 bits" do
      interpreter = Interpreter.new()
      y = 0x5
      y_value = 0xD5
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: 0x9}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SHL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0xAA == executed_interpreter.v[vx.value]
    end
  end
end
