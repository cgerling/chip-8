defmodule Chip8.Runtime.Instruction.XOR do
  @moduledoc false

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    xor_result = Bitwise.bxor(runtime.v[x.value], runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, xor_result)
    %{runtime | v: v_registers}
  end
end
