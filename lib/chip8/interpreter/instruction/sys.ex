defmodule Chip8.Interpreter.Instruction.SYS do
  @moduledoc """
  Call a native subroutine.

  It is not possible to call the native subroutines that were available in
  the computers where Chip-8 was introduced so this instruction is
  essentially a no-op.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `0nnn`  | `SYS address`         | No-op.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Address{}}) do
    interpreter
  end
end
