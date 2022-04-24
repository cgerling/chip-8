defmodule Chip8.Interpreter.Instruction.SNE do
  @moduledoc """
  Skip the next instruction when values are not equal.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `4xkk`  | `SNE Vx, byte`        | Skip the next instruction if `Vx != byte`.
  `9xy0`  | `SNE Vx, Vy`          | Skip the next instruction if `Vx != Vy`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Byte{} = byte}) do
    if interpreter.v[x.value] != byte.value,
      do: Interpreter.to_next_instruction(interpreter),
      else: interpreter
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    if interpreter.v[x.value] != interpreter.v[y.value],
      do: Interpreter.to_next_instruction(interpreter),
      else: interpreter
  end
end
