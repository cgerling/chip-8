defmodule Chip8.Runtime.Instruction.XORTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.XOR

  describe "execute/2" do
    test "should return a runtime with vx set to the result of a bitwise xor of vx and vy" do
      runtime = Runtime.new()
      x = 0x1
      x_value = 0x7F
      runtime = put_in(runtime.v[x], x_value)
      y = 0x7
      y_value = 0x44
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = XOR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x3B == executed_runtime.v[vx.value]
    end
  end
end
