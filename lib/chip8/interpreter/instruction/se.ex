defmodule Chip8.Interpreter.Instruction.SE do
  @moduledoc """
  Skip the next instruction when values are equal.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `3xkk`  | `SE Vx, byte`         | Skip next instruction if `Vx == byte`.
  `5xy0`  | `SE Vx, Vy`           | Skip next instruction if `Vx == Vy`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Byte{} = byte}) do
    if interpreter.v[x.value] == byte.value,
      do: Interpreter.to_next_instruction(interpreter),
      else: interpreter
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    if interpreter.v[x.value] == interpreter.v[y.value],
      do: Interpreter.to_next_instruction(interpreter),
      else: interpreter
  end
end
