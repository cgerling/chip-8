defmodule Chip8.Runtime.Instruction.XOR do
  @moduledoc """
  Calculates the _bitwise XOR_ between two operands.

  The result of this operation is saved in the first operand.
  An _exclusive OR_ compares the corresponding bits of the values, when neither of
  the bits are the same it results in a 1, and 0 otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy3`  | `XOR Vx, Vy`          | Set `Vx = Vx XOR Vy`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    xor_result = Bitwise.bxor(runtime.v[x.value], runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, xor_result)
    %{runtime | v: v_registers}
  end
end
