defmodule Chip8.Instruction.SHRTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SHR
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register F set to the least significant bit of v register y" do
      runtime = Runtime.new()
      x = 0xA
      y = 0x2
      y_value = 0x85
      v_registers = VRegisters.set(runtime.v, y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SHR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register x set to v register y shifted one bit to the right" do
      runtime = Runtime.new()
      x = 0xC
      y = 0x3
      y_value = 0xAD
      v_registers = VRegisters.set(runtime.v, y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SHR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x56 == executed_runtime.v[x]
    end
  end
end
