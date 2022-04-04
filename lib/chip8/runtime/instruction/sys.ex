defmodule Chip8.Runtime.Instruction.SYS do
  @moduledoc false

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Address{}}) do
    runtime
  end
end
