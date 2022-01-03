defmodule Chip8.Instruction.XORTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.XOR
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with vx set to the result of a bitwise xor of vx and vy" do
      runtime = Runtime.new()
      x = 0x1
      x_value = 0x7F
      runtime = put_in(runtime.v[x], x_value)
      y = 0x7
      y_value = 0x44
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = XOR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x3B == executed_runtime.v[x]
    end
  end
end
