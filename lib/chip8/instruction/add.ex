defmodule Chip8.Instruction.ADD do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    register_x = VRegisters.get(runtime.v, x)

    add_result = register_x + byte

    v_registers = VRegisters.set(runtime.v, x, add_result)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_x = VRegisters.get(runtime.v, x)
    register_y = VRegisters.get(runtime.v, y)

    add_result = register_x + register_y

    v_registers = VRegisters.set(runtime.v, x, add_result)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x}) do
    register_x = VRegisters.get(runtime.v, x)

    add_result = runtime.i + register_x

    %{runtime | i: add_result}
  end
end
