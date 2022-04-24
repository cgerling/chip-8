defmodule Chip8.Interpreter.Instruction.RND do
  @moduledoc """
  Generates a random 8-bit integer.

  The interpreter generates a random 8-bit integer and calculates the 
  _bitwise AND_ with the given byte.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `Cxkk`  | `RND Vx, byte`        | Set `Vx = random byte AND byte`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters
  alias Chip8.UInt

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Byte{} = byte}) do
    random_byte = :rand.uniform(0xFF)
    byte = UInt.to_uint8(byte.value)

    rnd_result = Bitwise.band(random_byte, byte)

    v_registers = VRegisters.set(interpreter.v, x.value, rnd_result)
    %{interpreter | v: v_registers}
  end
end
