defmodule Chip8.Instruction.SUBN do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.UInt
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    sub_result = UInt.to_uint8(runtime.v[y] - runtime.v[x])
    carry_flag = if runtime.v[y] > runtime.v[x], do: 1, else: 0

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, carry_flag)
      |> VRegisters.set(x, sub_result)

    %{runtime | v: v_registers}
  end
end
