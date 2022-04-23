defmodule Chip8.Runtime.Instruction.JP do
  @moduledoc """
  Jump to a memory address.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `1nnn`  | `JP address`          | Set `pc = address`.
  `Bnnn`  | `JP V0, address`      | Set `pc = V0 + address`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.UInt

  @v0 Register.v(0x0)

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Address{} = address}) do
    pc = UInt.to_uint12(address.value)
    %{runtime | pc: pc}
  end

  def execute(%Runtime{} = runtime, {@v0, %Address{} = address}) do
    pc = UInt.to_uint12(address.value + runtime.v[0x0])
    %{runtime | pc: pc}
  end
end
