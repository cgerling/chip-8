defmodule Chip8.Instruction.XORTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.XOR
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register x set to the result of a bitwise xor of v register x and v register y" do
      runtime = Runtime.new()
      x = 0x1
      x_value = 0x7F
      y = 0x7
      y_value = 0x44
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = XOR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x3B == VRegisters.get(executed_runtime.v, x)
    end
  end
end
