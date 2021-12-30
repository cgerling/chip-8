defmodule Chip8.Instruction.SHL do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_y = VRegisters.get(runtime.v, y)
    most_significant_bit = register_y |> Bitwise.band(0b10000000) |> Bitwise.bsr(7)
    sl_result = Bitwise.bsl(register_y, 1)

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, most_significant_bit)
      |> VRegisters.set(x, sl_result)

    %{runtime | v: v_registers}
  end
end
