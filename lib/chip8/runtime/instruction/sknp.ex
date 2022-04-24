defmodule Chip8.Runtime.Instruction.SKNP do
  @moduledoc """
  Skip the next instruction when a specific key is not pressed.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `ExA1`  | `SKNP Vx`             | Skip the next instruction if the key with the value of `Vx` is not pressed.
  """

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
