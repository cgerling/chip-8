defmodule Chip8.Instruction.SHLTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SHL
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register F set to the most significant bit of v register y" do
      runtime = Runtime.new()
      x = 0x8
      y = 0x0
      y_value = 0xF7
      v_registers = VRegisters.set(runtime.v, y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SHL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register x set to v register y shifted one bit to the left" do
      runtime = Runtime.new()
      x = 0x9
      y = 0x5
      y_value = 0x45
      v_registers = VRegisters.set(runtime.v, y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SHL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x8A == executed_runtime.v[x]
    end
  end
end
