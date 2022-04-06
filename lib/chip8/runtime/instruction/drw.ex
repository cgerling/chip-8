defmodule Chip8.Runtime.Instruction.DRW do
  @moduledoc false

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
