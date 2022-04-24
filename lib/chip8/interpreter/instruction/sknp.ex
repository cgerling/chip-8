defmodule Chip8.Interpreter.Instruction.SKNP do
  @moduledoc """
  Skip the next instruction when a specific key is not pressed.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `ExA1`  | `SKNP Vx`             | Skip the next instruction if the key with the value of `Vx` is not pressed.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Keyboard

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x}) do
    if Keyboard.is_pressed?(interpreter.keyboard, interpreter.v[x.value]),
      do: interpreter,
      else: Interpreter.to_next_instruction(interpreter)
  end
end
