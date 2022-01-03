defmodule Chip8.Instruction.RNDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.RND
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with v register x set to the result of a bitwise and of a random byte and the given byte" do
      runtime = Runtime.new()

      seed = {1406, 407_414, 139_258}
      :rand.seed(:exsss, seed)

      x = :rand.uniform(0xF)
      byte = 0x8A
      arguments = %{x: x, byte: byte}
      executed_runtime = RND.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x8 == executed_runtime.v[x]
    end
  end
end
