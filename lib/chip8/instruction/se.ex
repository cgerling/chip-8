defmodule Chip8.Instruction.SE do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction
  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    register_x = VRegisters.get(runtime.v, x)
    skip_value = if register_x == byte, do: Instruction.byte_size(), else: 0

    %{runtime | pc: runtime.pc + skip_value}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_x = VRegisters.get(runtime.v, x)
    register_y = VRegisters.get(runtime.v, y)
    skip_value = if register_x == register_y, do: Instruction.byte_size(), else: 0

    %{runtime | pc: runtime.pc + skip_value}
  end
end
