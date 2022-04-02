defmodule Chip8.Instruction.AND do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Register
  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    and_result = Bitwise.band(runtime.v[x.value], runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, and_result)
    %{runtime | v: v_registers}
  end
end
