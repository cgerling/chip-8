defmodule Chip8.Instruction.ANDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.AND
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with v register x set to the result of a bitwise and of v register x and v register y" do
      runtime = Runtime.new()
      x = 0xB
      x_value = 0x43
      runtime = put_in(runtime.v[x], x_value)
      y = 0x4
      y_value = 0xC1
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = AND.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x41 == executed_runtime.v[x]
    end
  end
end
