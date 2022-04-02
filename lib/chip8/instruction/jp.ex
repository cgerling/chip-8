defmodule Chip8.Instruction.JP do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Address
  alias Chip8.Runtime
  alias Chip8.UInt

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: 0, address: address}) do
    pc = UInt.to_uint12(address + runtime.v[0x0])
    %{runtime | pc: pc}
  end

  def execute(%Runtime{} = runtime, {%Address{} = address}) do
    pc = UInt.to_uint12(address.value)
    %{runtime | pc: pc}
  end
end
