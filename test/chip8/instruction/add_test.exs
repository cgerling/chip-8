defmodule Chip8.Instruction.ADDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.ADD
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      arguments = %{x: x, byte: byte}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with v register x set to the sum of v register x and the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0xF8
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      byte = 0x2B
      arguments = %{x: x, byte: byte}
      executed_runtime = ADD.execute(runtime, arguments)

      assert 0x123 == VRegisters.get(executed_runtime.v, x)
    end
  end
end
