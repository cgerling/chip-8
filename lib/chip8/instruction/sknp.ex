defmodule Chip8.Instruction.SKNP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Register
  alias Chip8.Keyboard
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x}) do
    if Keyboard.is_pressed?(runtime.keyboard, runtime.v[x.value]),
      do: runtime,
      else: Runtime.to_next_instruction(runtime)
  end
end
