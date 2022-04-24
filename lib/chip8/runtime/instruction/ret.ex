defmodule Chip8.Runtime.Instruction.RET do
  @moduledoc """
  Return from a subroutine.

  In case there is not a subroutine to return from, nothing is done.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `00EE`  | `RET`                 | Set `pc = address at the top of the stack`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Stack

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {}) do
    case Stack.pop(runtime.stack) do
      {nil, _stack} -> runtime
      {address, stack} -> %{runtime | pc: address, stack: stack}
    end
  end
end
