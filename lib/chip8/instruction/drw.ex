defmodule Chip8.Instruction.DRW do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Display
  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.Sprite
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, y: y, nibble: nibble}) do
    sprite =
      runtime.memory
      |> Memory.read(runtime.i, nibble)
      |> Sprite.new()

    coordinates = Display.get_coordinates(runtime.display, runtime.v[x], runtime.v[y])

    drawed_display = Display.draw(runtime.display, coordinates, sprite)

    collision = if Display.has_collision?(runtime.display, drawed_display), do: 1, else: 0
    v_registers = VRegisters.set(runtime.v, 0xF, collision)
    %{runtime | display: drawed_display, v: v_registers}
  end
end
