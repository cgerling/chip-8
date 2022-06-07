defmodule Chip8.Interpreter.Instruction.ADD do
  @moduledoc """
  Adds the first operand with the second operand.

  This operation always returns an 8-bit number, that is stored in the first
  operand. When an _overflow happens, the result is always wrapped to fit into
  the specified size.

  In some variants a _carry_ bit is also returned, when an _overflow_ happens
  the carry bit will be `1`, and `0` otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `7xkk`  | `ADD Vx, byte`        | Set `Vx = Vx + byte`.
  `8xy4`  | `ADD Vx, Vy`          | Set `Vx = Vx + Vy` and `VF = carry`.
  `Fx1E`  | `ADD I, Vx`           | Set `I = I + Vx`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.VRegisters
  alias Chip8.UInt

  @i Register.i()

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Byte{} = byte}) do
    add_result = UInt.to_uint8(interpreter.v[x.value] + byte.value)

    v_registers = VRegisters.set(interpreter.v, x.value, add_result)
    %{interpreter | v: v_registers}
  end

  def execute(%Interpreter{} = interpreter, {@i, %Register{} = x}) do
    add_result = UInt.to_uint16(interpreter.i + interpreter.v[x.value])

    %{interpreter | i: add_result}
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    result = interpreter.v[x.value] + interpreter.v[y.value]
    carry = if result > 255, do: 1, else: 0

    add_result = UInt.to_uint8(result)

    v_registers =
      interpreter.v
      |> VRegisters.set(x.value, add_result)
      |> VRegisters.set(0xF, carry)

    %{interpreter | v: v_registers}
  end
end
