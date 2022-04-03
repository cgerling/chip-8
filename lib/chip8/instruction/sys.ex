defmodule Chip8.Instruction.SYS do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Address
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {%Address{}}) do
    runtime
  end
end
