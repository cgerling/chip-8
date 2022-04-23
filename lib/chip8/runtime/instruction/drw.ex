defmodule Chip8.Runtime.Instruction.DRW do
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

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Display
  alias Chip8.Runtime.Instruction.Argument.Nibble
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Memory
  alias Chip8.Runtime.VRegisters

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y, %Nibble{} = nibble}) do
    sprite =
      runtime.memory
      |> Memory.read(runtime.i, nibble.value)
      |> Display.create_sprite()

    coordinates = Display.get_coordinates(runtime.display, runtime.v[x.value], runtime.v[y.value])

    drawed_display = Display.draw(runtime.display, coordinates, sprite)

    collision = if Display.has_collision?(runtime.display, drawed_display), do: 1, else: 0
    v_registers = VRegisters.set(runtime.v, 0xF, collision)
    %{runtime | display: drawed_display, v: v_registers}
  end
end
