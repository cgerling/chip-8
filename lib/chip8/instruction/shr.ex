defmodule Chip8.Instruction.SHR do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    least_significant_bit = Bitwise.band(runtime.v[y], 0b00000001)
    sr_result = Bitwise.bsr(runtime.v[y], 1)

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, least_significant_bit)
      |> VRegisters.set(x, sr_result)

    %{runtime | v: v_registers}
  end
end
