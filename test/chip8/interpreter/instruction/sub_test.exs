defmodule Chip8.Interpreter.Instruction.SUBTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SUB

  describe "execute/2" do
    test "should return an interpreter with vx set to the difference of vx and vy wrapped to 8 bits when vx is larger than vy" do
      interpreter = Interpreter.new()
      x = 0x5
      x_value = 0x36
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x0
      y_value = 0x29
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUB.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x0D == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the difference of vx and vy wrapped to 8 bits when vx is equals to vy wrapped to 8 bits" do
      interpreter = Interpreter.new()
      x = 0xB
      y = 0x2
      value = 0x25
      interpreter = put_in(interpreter.v[x], value)
      interpreter = put_in(interpreter.v[y], value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUB.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x0 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the difference of vx and vy wrapped to 8 bits when vx is less than vy wrapped to 8 bits" do
      interpreter = Interpreter.new()
      x = 0xB
      x_value = 0x1D
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x2
      y_value = 0xE3
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUB.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x3A == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with v register F set to 1 when vx is greather than vy" do
      interpreter = Interpreter.new()
      x = 0x3
      x_value = 0xD5
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0xF
      y_value = 0x9F
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUB.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 1 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with v register F set to 0 when vx is equals to vy" do
      interpreter = Interpreter.new()
      x = 0xC
      y = 0x5
      value = 0x19
      interpreter = put_in(interpreter.v[x], value)
      interpreter = put_in(interpreter.v[y], value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUB.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with v register F set to 0 when vx is less than vy" do
      interpreter = Interpreter.new()
      x = 0xC
      x_value = 0xBC
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x5
      y_value = 0xF4
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUB.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0 == executed_interpreter.v[0xF]
    end
  end
end
