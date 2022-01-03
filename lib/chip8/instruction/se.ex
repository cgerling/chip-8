defmodule Chip8.Instruction.SE do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    skip_value = if runtime.v[x] == byte, do: Instruction.byte_size(), else: 0

    %{runtime | pc: runtime.pc + skip_value}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    skip_value = if runtime.v[x] == runtime.v[y], do: Instruction.byte_size(), else: 0

    %{runtime | pc: runtime.pc + skip_value}
  end
end
