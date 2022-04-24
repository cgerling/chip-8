defmodule Chip8.Runtime.Instruction.SNE do
  @moduledoc """
  Skip the next instruction when values are not equal.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `4xkk`  | `SNE Vx, byte`        | Skip the next instruction if `Vx != byte`.
  `9xy0`  | `SNE Vx, Vy`          | Skip the next instruction if `Vx != Vy`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Register

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    if runtime.v[x.value] != byte.value,
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    if runtime.v[x.value] != runtime.v[y.value],
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end
end
