defmodule Chip8.Runtime.Instruction.SNETest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.SNE
  alias Chip8.Runtime.VRegisters

  describe "execute/2" do
    test "should return a runtime with pc unchanged when vx is equals to the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      v_registers = VRegisters.set(runtime.v, x, byte)
      runtime = put_in(runtime.v, v_registers)

      vx = %Register{value: x}
      byte = %Byte{value: byte}
      arguments = {vx, byte}
      executed_runtime = SNE.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc == executed_runtime.pc
    end

    test "should return a runtime with pc set to next instruction when vx is not equals to the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0x95
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      vx = %Register{value: x}
      byte = %Byte{value: 0xF2}
      arguments = {vx, byte}
      executed_runtime = SNE.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc + 2 == executed_runtime.pc
    end

    test "should return a runtime with pc unchanged when vx is equals to vy" do
      runtime = Runtime.new()
      value = :rand.uniform(0xFF)
      x = 0x2
      y = 0x9
      v_registers = runtime.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      runtime = put_in(runtime.v, v_registers)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SNE.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc == executed_runtime.pc
    end

    test "should return a runtime with pc set to next instruction when vx is not equals to vy" do
      runtime = Runtime.new()
      x = 0xE
      x_value = 0x95
      y = 0x3
      y_value = 0x10
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SNE.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc + 2 == executed_runtime.pc
    end
  end
end
