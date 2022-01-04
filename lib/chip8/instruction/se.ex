defmodule Chip8.Instruction.SE do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    if runtime.v[x] == byte,
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    if runtime.v[x] == runtime.v[y],
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end
end
