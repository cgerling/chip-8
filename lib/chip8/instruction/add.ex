defmodule Chip8.Instruction.ADD do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.UInt
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: :i, y: y}) do
    add_result = UInt.to_uint16(runtime.i + runtime.v[y])

    %{runtime | i: add_result}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    add_result = UInt.to_uint8(runtime.v[x] + runtime.v[y])

    v_registers = VRegisters.set(runtime.v, x, add_result)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    add_result = UInt.to_uint8(runtime.v[x] + byte)

    v_registers = VRegisters.set(runtime.v, x, add_result)
    %{runtime | v: v_registers}
  end
end
