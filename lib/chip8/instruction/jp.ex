defmodule Chip8.Instruction.JP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: 0, address: address}) do
    register_0 = VRegisters.get(runtime.v, 0)

    pc = address + register_0
    %{runtime | pc: pc}
  end

  def execute(%Runtime{} = runtime, %{address: address}) do
    %{runtime | pc: address}
  end
end
