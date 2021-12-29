defmodule Chip8.Instruction.SNETest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SNE
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      arguments = %{x: x, byte: byte}
      executed_runtime = SNE.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with pc unchanged when v register x is equals to the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      v_registers = VRegisters.set(runtime.v, x, byte)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, byte: byte}
      executed_runtime = SNE.execute(runtime, arguments)

      assert runtime.pc == executed_runtime.pc
    end

    test "should return a runtime with pc set to next instruction when v register x is not equals to the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0x95
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      byte = 0xF2
      arguments = %{x: x, byte: byte}
      executed_runtime = SNE.execute(runtime, arguments)

      assert runtime.pc + 2 == executed_runtime.pc
    end
  end
end
