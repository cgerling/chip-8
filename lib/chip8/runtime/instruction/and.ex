defmodule Chip8.Runtime.Instruction.AND do
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

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    and_result = Bitwise.band(runtime.v[x.value], runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, and_result)
    %{runtime | v: v_registers}
  end
end
