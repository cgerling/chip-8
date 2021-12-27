defmodule Chip8.Fixture.IdentityInstruction do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{}) do
    runtime
  end
end
