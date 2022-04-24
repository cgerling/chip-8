defmodule Chip8.Interpreter.Instruction.SHR do
  @moduledoc """
  Calculates the result of an arithmetic _right bitshift_.

  The result of this operation is saved in the first operand.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy6`  | `SHR Vx {, Vy}`       | Set `Vx = Vx SHR 1` and `VF = Vx least-significant bit`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    least_significant_bit = Bitwise.band(interpreter.v[y.value], 0b00000001)
    sr_result = Bitwise.bsr(interpreter.v[y.value], 1)

    v_registers =
      interpreter.v
      |> VRegisters.set(0xF, least_significant_bit)
      |> VRegisters.set(x.value, sr_result)

    %{interpreter | v: v_registers}
  end
end
