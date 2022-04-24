defmodule Chip8.Interpreter.Instruction.XOR do
  @moduledoc """
  Calculates the _bitwise XOR_ between two operands.

  The result of this operation is saved in the first operand.
  An _exclusive OR_ compares the corresponding bits of the values, when neither of
  the bits are the same it results in a 1, and 0 otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `8xy3`  | `XOR Vx, Vy`          | Set `Vx = Vx XOR Vy`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    xor_result = Bitwise.bxor(interpreter.v[x.value], interpreter.v[y.value])

    v_registers = VRegisters.set(interpreter.v, x.value, xor_result)
    %{interpreter | v: v_registers}
  end
end
