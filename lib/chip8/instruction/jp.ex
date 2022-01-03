defmodule Chip8.Instruction.JP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: 0, address: address}) do
    pc = address + runtime.v[0x0]
    %{runtime | pc: pc}
  end

  def execute(%Runtime{} = runtime, %{address: address}) do
    %{runtime | pc: address}
  end
end
