defmodule Chip8.Runtime.Instruction.CLS do
  @moduledoc """
  Clear the display's contents.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `00E0`  | `CLS`                 | Clear the display's contents.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Display

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {}) do
    cleared_display = Display.clear(runtime.display)

    %{runtime | display: cleared_display}
  end
end
