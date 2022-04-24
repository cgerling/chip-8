defmodule Chip8.Interpreter.Instruction.AND do
  @moduledoc """
  Calculates the _bitwise AND_ between two operands.

  The result of this operation is saved into the first operand.
  A _bitwise AND_ compares the corresponding bits of the values, when both of
  the bits are 1 it results in a 1, and 0 otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy2`  | `ADD Vx, Vy`          | Set `Vx = Vy AND Vy`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    and_result = Bitwise.band(interpreter.v[x.value], interpreter.v[y.value])

    v_registers = VRegisters.set(interpreter.v, x.value, and_result)
    %{interpreter | v: v_registers}
  end
end
