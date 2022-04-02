defmodule Chip8.Instruction.SNE do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    if runtime.v[x.value] != byte.value,
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    if runtime.v[x] != runtime.v[y],
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end
end
