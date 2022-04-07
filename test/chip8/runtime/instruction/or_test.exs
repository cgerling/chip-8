defmodule Chip8.Runtime.Instruction.ORTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.OR
  alias Chip8.Runtime.VRegisters

  describe "execute/2" do
    test "should return a runtime with vx set to the result of a bitwise or of vx and vy" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0xD1
      y = 0xA
      y_value = 0x85
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = OR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xD5 == executed_runtime.v[vx.value]
    end
  end
end