defmodule Chip8.Runtime.Instruction.SHR do
  @moduledoc """
  Calculates the result of an arithmetic _right bitshift_.

  The result of this operation is saved in the first operand.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy6`  | `SHR Vx {, Vy}`       | Set `Vx = Vx SHR 1` and `VF = Vx least-significant bit`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    least_significant_bit = Bitwise.band(runtime.v[y.value], 0b00000001)
    sr_result = Bitwise.bsr(runtime.v[y.value], 1)

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, least_significant_bit)
      |> VRegisters.set(x.value, sr_result)

    %{runtime | v: v_registers}
  end
end
