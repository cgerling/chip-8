defmodule Chip8.Instruction.SKNP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction
  alias Chip8.Keyboard
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x}) do
    skip_value =
      if Keyboard.is_pressed?(runtime.keyboard, runtime.v[x]),
        do: 0,
        else: Instruction.byte_size()

    %{runtime | pc: runtime.pc + skip_value}
  end
end
