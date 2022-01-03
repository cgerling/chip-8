defmodule Chip8.Instruction.ADDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.ADD
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with i set to the sum of i and v register y" do
      runtime = Runtime.new()
      i_value = 0x64
      runtime = put_in(runtime.i, i_value)
      y = 0xC
      y_value = 0x2C
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: :i, y: y}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x90 == executed_runtime.i
    end

    test "should return a runtime with v register x set to the sum of v register x and v register y" do
      runtime = Runtime.new()
      x = 0x9
      x_value = 0x2C
      runtime = put_in(runtime.v[x], x_value)
      y = 0xD
      y_value = 0x84
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xB0 == executed_runtime.v[x]
    end

    test "should return a runtime with v register x set to the sum of v register x and the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0xF8
      runtime = put_in(runtime.v[x], x_value)

      byte = 0x2B
      arguments = %{x: x, byte: byte}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x123 == executed_runtime.v[x]
    end
  end
end
