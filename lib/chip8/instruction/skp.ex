defmodule Chip8.Instruction.SKP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Keyboard
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x}) do
    if Keyboard.is_pressed?(runtime.keyboard, runtime.v[x]),
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end
end
