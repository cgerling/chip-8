defmodule Chip8.Interpreter.Instruction.CALL do
  @moduledoc """
  Call a subroutine.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `2nnn`  | `CALL address`        | Push the current `pc` to the stack and then set `pc = address`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Stack

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Address{} = address}) do
    pushed_stack = Stack.push(interpreter.stack, interpreter.pc)

    %{interpreter | pc: address.value, stack: pushed_stack}
  end
end
