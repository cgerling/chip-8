defmodule Chip8.Interpreter.Instruction.RET do
  @moduledoc """
  Return from a subroutine.

  In case there is not a subroutine to return from, nothing is done.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `00EE`  | `RET`                 | Set `pc = address at the top of the stack`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Stack

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {}) do
    case Stack.pop(interpreter.stack) do
      {nil, _stack} -> interpreter
      {address, stack} -> %{interpreter | pc: address, stack: stack}
    end
  end
end
