defmodule Chip8.Instruction.SHR do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_y = VRegisters.get(runtime.v, y)
    least_significant_bit = Bitwise.band(register_y, 0b00000001)
    sr_result = Bitwise.bsr(register_y, 1)

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, least_significant_bit)
      |> VRegisters.set(x, sr_result)

    %{runtime | v: v_registers}
  end
end
