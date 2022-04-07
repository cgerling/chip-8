defmodule Chip8.Runtime.Instruction.SUB do
  @moduledoc false

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters
  alias Chip8.UInt

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    sub_result = UInt.to_uint8(runtime.v[x.value] - runtime.v[y.value])
    carry_flag = if runtime.v[x.value] > runtime.v[y.value], do: 1, else: 0

    v_registers =
      runtime.v
      |> VRegisters.set(0xF, carry_flag)
      |> VRegisters.set(x.value, sub_result)

    %{runtime | v: v_registers}
  end
end