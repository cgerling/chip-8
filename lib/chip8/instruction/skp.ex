defmodule Chip8.Instruction.SKP do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Instruction
  alias Chip8.Keyboard
  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x}) do
    register_x = VRegisters.get(runtime.v, x)

    skip_value =
      if Keyboard.is_pressed?(runtime.keyboard, register_x), do: Instruction.byte_size(), else: 0

    %{runtime | pc: runtime.pc + skip_value}
  end
end
