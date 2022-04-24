defmodule Chip8.Interpreter.Instruction.JP do
  @moduledoc """
  Jump to a memory address.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `1nnn`  | `JP address`          | Set `pc = address`.
  `Bnnn`  | `JP V0, address`      | Set `pc = V0 + address`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.UInt

  @v0 Register.v(0x0)

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Address{} = address}) do
    pc = UInt.to_uint12(address.value)
    %{interpreter | pc: pc}
  end

  def execute(%Interpreter{} = interpreter, {@v0, %Address{} = address}) do
    pc = UInt.to_uint12(address.value + interpreter.v[0x0])
    %{interpreter | pc: pc}
  end
end
