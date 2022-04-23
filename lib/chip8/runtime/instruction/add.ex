defmodule Chip8.Runtime.Instruction.ADD do
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

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.VRegisters
  alias Chip8.UInt

  @i Register.i()

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    add_result = UInt.to_uint8(runtime.v[x.value] + byte.value)

    v_registers = VRegisters.set(runtime.v, x.value, add_result)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {@i, %Register{} = x}) do
    add_result = UInt.to_uint16(runtime.i + runtime.v[x.value])

    %{runtime | i: add_result}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    add_result = UInt.to_uint8(runtime.v[x.value] + runtime.v[y.value])

    v_registers = VRegisters.set(runtime.v, x.value, add_result)
    %{runtime | v: v_registers}
  end
end
