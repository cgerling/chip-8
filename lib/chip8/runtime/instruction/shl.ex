defmodule Chip8.Runtime.Instruction.SHL do
  @moduledoc """
  Calculates the result of an arithmetic _left bitshift_.

  The result of this operation is stored in the first operand.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xyE`  | `SHL Vx {, Vy}`       | Set `Vx = Vx SHL 1` and `VF = Vx most-significant bit`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters
  alias Chip8.UInt

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    most_significant_bit = runtime.v[y.value] |> Bitwise.band(0b10000000) |> Bitwise.bsr(7)
    sl_result = runtime.v[y.value] |> Bitwise.bsl(1) |> UInt.to_uint8()

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, most_significant_bit)
      |> VRegisters.set(x.value, sl_result)

    %{runtime | v: v_registers}
  end
end
