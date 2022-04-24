defmodule Chip8.Interpreter.Instruction.SUBN do
  @moduledoc """
  Subtracts the second operand with the first operand.

  This operation always returns an 8-bit number, that is stored in the first
  operand. When an _underflow_ happens, the result is always wrapped to fit into
  the specified size.

  In some variants a _borrow_ bit is also returned, when an _underflow_ happens
  the borrow bit will be `1`, and `0` otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy7`  | `SUBN Vx, Vy`         | Set `Vx = Vy - Vx` and `VF = NOT borrow`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters
  alias Chip8.UInt

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    sub_result = UInt.to_uint8(interpreter.v[y.value] - interpreter.v[x.value])
    carry_flag = if interpreter.v[y.value] > interpreter.v[x.value], do: 1, else: 0

    v_registers =
      interpreter.v
      |> VRegisters.set(0xF, carry_flag)
      |> VRegisters.set(x.value, sub_result)

    %{interpreter | v: v_registers}
  end
end
