defmodule Chip8.Fixture.ArgumentsInstruction do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{value: value}) do
    %{runtime | pc: value}
  end
end
