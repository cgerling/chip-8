defmodule Chip8.Instruction.XOR do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_x = VRegisters.get(runtime.v, x)
    register_y = VRegisters.get(runtime.v, y)

    xor_result = Bitwise.bxor(register_x, register_y)

    v_registers = VRegisters.set(runtime.v, x, xor_result)
    %{runtime | v: v_registers}
  end
end
