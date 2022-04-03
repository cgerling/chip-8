defmodule Chip8.Instruction.RNDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Instruction.RND
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with vx set to the result of a bitwise and of a random byte and the given byte" do
      runtime = Runtime.new()

      seed = {1406, 407_414, 139_258}
      :rand.seed(:exsss, seed)

      vx = %Register{value: :rand.uniform(0xF)}
      byte = %Byte{value: 0x8A}
      arguments = {vx, byte}
      executed_runtime = RND.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x8 == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the result of a bitwise and of a random byte and the given byte wrapped to 8 bits" do
      runtime = Runtime.new()

      seed = {1406, 407_414, 139_258}
      :rand.seed(:exsss, seed)

      vx = %Register{value: :rand.uniform(0xF)}
      byte = %Byte{value: 0x32A}
      arguments = {vx, byte}
      executed_runtime = RND.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x8 == executed_runtime.v[vx.value]
    end
  end
end
