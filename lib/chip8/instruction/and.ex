defmodule Chip8.Instruction.AND do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_x = VRegisters.get(runtime.v, x)
    register_y = VRegisters.get(runtime.v, y)

    and_result = Bitwise.band(register_x, register_y)

    v_registers = VRegisters.set(runtime.v, x, and_result)
    %{runtime | v: v_registers}
  end
end
