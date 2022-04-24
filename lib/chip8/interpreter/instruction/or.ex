defmodule Chip8.Interpreter.Instruction.OR do
  @moduledoc """
  Calculates the _bitwise OR_ between two operands.

  The result of this operation is stored in the first operand.
  A _bitwise OR_ compares the corresponding bits of the values, when either of
  the bits is 1 it results in a 1, and 0 otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy1`  | `OR Vx, Vy`           | Set `Vx = Vx OR Vy`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    or_result = Bitwise.bor(interpreter.v[x.value], interpreter.v[y.value])

    v_registers = VRegisters.set(interpreter.v, x.value, or_result)
    %{interpreter | v: v_registers}
  end
end
