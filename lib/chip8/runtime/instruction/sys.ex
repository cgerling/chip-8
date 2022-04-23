defmodule Chip8.Runtime.Instruction.SYS do
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

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Address{}}) do
    runtime
  end
end
