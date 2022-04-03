defmodule Chip8.Instruction.ADD do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Runtime
  alias Chip8.UInt
  alias Chip8.VRegisters

  @i Register.i()

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    add_result = UInt.to_uint8(runtime.v[x.value] + byte.value)

    v_registers = VRegisters.set(runtime.v, x.value, add_result)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {@i, %Register{} = x}) do
    add_result = UInt.to_uint16(runtime.i + runtime.v[x.value])

    %{runtime | i: add_result}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    add_result = UInt.to_uint8(runtime.v[x.value] + runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, add_result)
    %{runtime | v: v_registers}
  end
end
