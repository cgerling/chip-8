defmodule Chip8.Runtime.Instruction.SKNP do
  @moduledoc false

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Keyboard

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x}) do
    if Keyboard.is_pressed?(runtime.keyboard, runtime.v[x.value]),
      do: runtime,
      else: Runtime.to_next_instruction(runtime)
  end
end
