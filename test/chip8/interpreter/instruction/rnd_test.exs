defmodule Chip8.Interpreter.Instruction.RNDTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.RND

  describe "execute/2" do
    test "should return an interpreter with vx set to the result of a bitwise and of a random byte and the given byte" do
      interpreter = Interpreter.new()

      seed = {1406, 407_414, 139_258}
      :rand.seed(:exsss, seed)

      vx = %Register{value: :rand.uniform(0xF)}
      byte = %Byte{value: 0x8A}
      arguments = {vx, byte}
      executed_interpreter = RND.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x8 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the result of a bitwise and of a random byte and the given byte wrapped to 8 bits" do
      interpreter = Interpreter.new()

      seed = {1406, 407_414, 139_258}
      :rand.seed(:exsss, seed)

      vx = %Register{value: :rand.uniform(0xF)}
      byte = %Byte{value: 0x32A}
      arguments = {vx, byte}
      executed_interpreter = RND.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x8 == executed_interpreter.v[vx.value]
    end
  end
end
