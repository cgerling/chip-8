defmodule Chip8.Instruction.SYS do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{address: _}) do
    runtime
  end
end
