defmodule Chip8.Instruction.OR do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    or_result = Bitwise.bor(runtime.v[x], runtime.v[y])

    v_registers = VRegisters.set(runtime.v, x, or_result)
    %{runtime | v: v_registers}
  end
end
