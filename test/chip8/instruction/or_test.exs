defmodule Chip8.Instruction.ORTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.OR
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register x set to the result of a bitwise or of v register x and v register y" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0xD1
      y = 0xA
      y_value = 0x85
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = OR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xD5 == executed_runtime.v[x]
    end
  end
end
