defmodule Chip8.Instruction.RND do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.UInt
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    random_byte = :rand.uniform(0xFF)
    byte = UInt.to_uint8(byte)

    rnd_result = Bitwise.band(random_byte, byte)

    v_registers = VRegisters.set(runtime.v, x, rnd_result)
    %{runtime | v: v_registers}
  end
end
