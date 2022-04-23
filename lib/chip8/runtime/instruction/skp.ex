defmodule Chip8.Runtime.Instruction.SKP do
  @moduledoc """
  Skip the next instruction when a specific key is pressed.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `Ex9E`  | `SKP Vx`              | Skip the next instruction if the key with the value of `Vx` is pressed.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Keyboard

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x}) do
    if Keyboard.is_pressed?(runtime.keyboard, runtime.v[x.value]),
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end
end
