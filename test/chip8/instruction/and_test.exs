defmodule Chip8.Instruction.ANDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.AND
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register x set to the result of a bitwise and of v register x and v register y" do
      runtime = Runtime.new()
      x = 0xB
      x_value = 0x43
      y = 0x4
      y_value = 0xC1
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = AND.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x41 == VRegisters.get(executed_runtime.v, x)
    end
  end
end
