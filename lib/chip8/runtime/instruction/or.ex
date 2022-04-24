defmodule Chip8.Runtime.Instruction.OR do
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

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    or_result = Bitwise.bor(runtime.v[x.value], runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, or_result)
    %{runtime | v: v_registers}
  end
end
