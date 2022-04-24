defmodule Chip8.Runtime.Instruction.SUB do
  @moduledoc """
  Subtracts the first operand with the second operand.

  This operation always returns an 8-bit number, that is stored in the first
  operand. When an _underflow_ happens, the result is always wrapped to fit into
  the specified size.

  In some variants a _borrow_ bit is also returned, when an _underflow_ happens
  the borrow bit will be `1`, and `0` otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy5`  | `SUB Vx, Vy`          | Set `Vx = Vx - Vy` and `VF = NOT borrow`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters
  alias Chip8.UInt

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    sub_result = UInt.to_uint8(runtime.v[x.value] - runtime.v[y.value])
    carry_flag = if runtime.v[x.value] > runtime.v[y.value], do: 1, else: 0

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, carry_flag)
      |> VRegisters.set(x.value, sub_result)

    %{runtime | v: v_registers}
  end
end
