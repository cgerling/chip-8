defmodule Chip8.Interpreter.Instruction.DRW do
  @moduledoc """
  Render sprites into the display.

  The sprite bytes are XORed against the corresponding bytes in the display,
  when a sprite is positioned in a way that part of it is located outside of
  the display coordinates, only the part considered inside of the display is
  rendered.

  A _collision_ flag is also returned and its value depends on the previous
  content of the display, if one or more pixels were erased during the current
  render call the collision flag is set to 1, and 0 otherwise.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `Dxyn`  | `DRW Vx, Vy, nibble`  | Display a n-byte sprite, stored on memory starting at location `I`, in the coordinates `(Vx, Vy)` and set `VF = collision`.
  """

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Instruction.Argument.Nibble
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Memory
  alias Chip8.Interpreter.VRegisters

  @impl Chip8.Interpreter.Instruction
  def execute(
        %Interpreter{} = interpreter,
        {%Register{} = x, %Register{} = y, %Nibble{} = nibble}
      ) do
    sprite =
      interpreter.memory
      |> Memory.read(interpreter.i, nibble.value)
      |> Display.create_sprite()

    coordinates =
      Display.get_coordinates(interpreter.display, interpreter.v[x.value], interpreter.v[y.value])

    {drawed_display, collision?} = Display.draw(interpreter.display, coordinates, sprite)

    collision = if collision?, do: 1, else: 0
    v_registers = VRegisters.set(interpreter.v, 0xF, collision)
    %{interpreter | display: drawed_display, v: v_registers}
  end
end
