defmodule Chip8.Instruction.SUBN do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_x = VRegisters.get(runtime.v, x)
    register_y = VRegisters.get(runtime.v, y)

    sub_result = abs(register_y - register_x)
    carry_flag = if register_y > register_x, do: 1, else: 0

    v_registers = runtime.v |> VRegisters.set(0xF, carry_flag) |> VRegisters.set(x, sub_result)
    %{runtime | v: v_registers}
  end
end
