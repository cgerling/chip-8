defmodule Chip8.Runtime.Instruction.CALL do
  @moduledoc """
  Call a subroutine.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `2nnn`  | `CALL address`        | Push the current `pc` to the stack and then set `pc = address`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Stack

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Address{} = address}) do
    pushed_stack = Stack.push(runtime.stack, runtime.pc)

    %{runtime | pc: address.value, stack: pushed_stack}
  end
end
