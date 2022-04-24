defmodule Chip8.Interpreter.Instruction.SKP do
  @moduledoc """
  Skip the next instruction when a specific key is pressed.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `Ex9E`  | `SKP Vx`              | Skip the next instruction if the key with the value of `Vx` is pressed.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Keyboard

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x}) do
    if Keyboard.is_pressed?(interpreter.keyboard, interpreter.v[x.value]),
      do: Interpreter.to_next_instruction(interpreter),
      else: interpreter
  end
end
