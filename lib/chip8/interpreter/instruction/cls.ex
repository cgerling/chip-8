defmodule Chip8.Interpreter.Instruction.CLS do
  @moduledoc """
  Clear the display's contents.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `00E0`  | `CLS`                 | Clear the display's contents.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {}) do
    cleared_display = Display.clear(interpreter.display)

    %{interpreter | display: cleared_display}
  end
end
