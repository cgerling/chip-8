defmodule Chip8.Instruction.JP do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{address: address}) do
    %{runtime | pc: address}
  end
end
