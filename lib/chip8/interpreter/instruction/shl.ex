defmodule Chip8.Interpreter.Instruction.SHL do
  @moduledoc """
  Calculates the result of an arithmetic _left bitshift_.

  The result of this operation is stored in the first operand.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xyE`  | `SHL Vx {, Vy}`       | Set `Vx = Vx SHL 1` and `VF = Vx most-significant bit`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters
  alias Chip8.UInt

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{}}) do
    most_significant_bit = interpreter.v[x.value] |> Bitwise.band(0b10000000) |> Bitwise.bsr(7)
    sl_result = interpreter.v[x.value] |> Bitwise.bsl(1) |> UInt.to_uint8()

    v_registers =
      interpreter.v
      |> VRegisters.set(0xF, most_significant_bit)
      |> VRegisters.set(x.value, sl_result)

    %{interpreter | v: v_registers}
  end
end
