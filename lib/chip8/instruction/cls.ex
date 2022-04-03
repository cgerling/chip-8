defmodule Chip8.Instruction.CLS do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Display
  alias Chip8.Runtime

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {}) do
    cleared_display = Display.clear(runtime.display)

    %{runtime | display: cleared_display}
  end
end
