defmodule Chip8.Instruction.SKP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction
  alias Chip8.Keyboard
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x}) do
    skip_value =
      if Keyboard.is_pressed?(runtime.keyboard, runtime.v[x]),
        do: Instruction.byte_size(),
        else: 0

    %{runtime | pc: runtime.pc + skip_value}
  end
end
