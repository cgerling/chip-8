defmodule Chip8.Runtime.Instruction.SE do
  @moduledoc false

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Register

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    if runtime.v[x.value] == byte.value,
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    if runtime.v[x.value] == runtime.v[y.value],
      do: Runtime.to_next_instruction(runtime),
      else: runtime
  end
end
