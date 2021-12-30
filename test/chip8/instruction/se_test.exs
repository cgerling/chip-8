defmodule Chip8.Instruction.SETest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SE
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      arguments = %{x: x, byte: byte}
      executed_runtime = SE.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with pc set to next instruction when v register x is equals to the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      v_registers = VRegisters.set(runtime.v, x, byte)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, byte: byte}
      executed_runtime = SE.execute(runtime, arguments)

      assert runtime.pc + 2 == executed_runtime.pc
    end

    test "should return a runtime with pc unchanged when v register x is not equals to the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0x95
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      byte = 0xF2
      arguments = %{x: x, byte: byte}
      executed_runtime = SE.execute(runtime, arguments)

      assert runtime.pc == executed_runtime.pc
    end

    test "should return a runtime with pc set to next instruction when v register x is equals to v register y" do
      runtime = Runtime.new()
      value = :rand.uniform(0xFF)
      x = 0xE
      y = 0x4

      v_registers = runtime.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SE.execute(runtime, arguments)

      assert runtime.pc + 2 == executed_runtime.pc
    end

    test "should return a runtime with pc unchanged when v register x is not equals to v register y" do
      runtime = Runtime.new()
      x = 0xE
      x_value = 0x95
      y = 0x4
      y_value = 0x1A

      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SE.execute(runtime, arguments)

      assert runtime.pc == executed_runtime.pc
    end
  end
end