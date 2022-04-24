defmodule Chip8.Interpreter.Instruction.ADDTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.ADD
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register

  describe "execute/2" do
    test "should return an interpreter with vx set to the sum of vx and the given byte" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = 0xF8
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      byte = %Byte{value: 0x2B}
      arguments = {vx, byte}
      executed_interpreter = ADD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x23 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the sum of vx and the given byte wrapped to 8 bits" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = 0xE9
      interpreter = put_in(interpreter.v[x], x_value)

      vx = %Register{value: x}
      byte = %Byte{value: 0xD4}
      arguments = {vx, byte}
      executed_interpreter = ADD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0xBD == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with i set to the sum of i and vx" do
      interpreter = Interpreter.new()
      i_value = 0x64
      interpreter = put_in(interpreter.i, i_value)
      x = 0xC
      x_value = 0x2C
      interpreter = put_in(interpreter.v[x], x_value)

      i = Register.i()
      vx = %Register{value: x}
      arguments = {i, vx}
      executed_interpreter = ADD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x90 == executed_interpreter.i
    end

    test "should return an interpreter with i set to the sum of i and vy wrapped to 16 bits" do
      interpreter = Interpreter.new()
      i_value = 0xFF36
      interpreter = put_in(interpreter.i, i_value)
      x = 0xC
      x_value = 0xE5
      interpreter = put_in(interpreter.v[x], x_value)

      i = Register.i()
      vx = %Register{value: x}
      arguments = {i, vx}
      executed_interpreter = ADD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x1B == executed_interpreter.i
    end

    test "should return an interpreter with vx set to the sum of vx and vy" do
      interpreter = Interpreter.new()
      x = 0x9
      x_value = 0x2C
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0xD
      y_value = 0x84
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = ADD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0xB0 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the sum of vx and vy wrapped to 8 bits" do
      interpreter = Interpreter.new()
      x = 0x9
      x_value = 0xAC
      interpreter = put_in(interpreter.v[x], x_value)
      y = 0xD
      y_value = 0x90
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = ADD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x3C == executed_interpreter.v[vx.value]
    end
  end
end
