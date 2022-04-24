defmodule Chip8.Interpreter.Instruction.SUBNTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.SUBN

  describe "execute/2" do
    test "should return an interpreter with vx set to the difference of vy and vx wrapped to 8 bits when vy is larger than vx" do
      interpreter = Interpreter.new()
      x = 0xC
      x_value = 0x83
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x1
      y_value = 0xE5
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUBN.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x62 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the difference of vy and vx wrapped to 8 bits when vy is equals to vx" do
      interpreter = Interpreter.new()
      x = 0xC
      y = 0x4
      value = 0x67
      interpreter = put_in(interpreter.v[x], value)
      interpreter = put_in(interpreter.v[y], value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUBN.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x0 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the difference of vy and vx wrapped to 8 bits when vy is less than vx" do
      interpreter = Interpreter.new()
      x = 0x0
      x_value = 0xB6
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x7
      y_value = 0x63
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUBN.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0xAD == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with v register F set to 1 when vy is greather than vx" do
      interpreter = Interpreter.new()
      x = 0xE
      x_value = 0x19
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x9
      y_value = 0x90
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUBN.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 1 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with v register F set to 0 when vy is equals to vx" do
      interpreter = Interpreter.new()
      x = 0xF
      y = 0xC
      value = 0xA0
      interpreter = put_in(interpreter.v[x], value)
      interpreter = put_in(interpreter.v[y], value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUBN.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with v register F set to 0 when vy is less than vx" do
      interpreter = Interpreter.new()
      x = 0xC
      x_value = 0x8B
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0x5
      y_value = 0x07
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = SUBN.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0 == executed_interpreter.v[0xF]
    end
  end
end
