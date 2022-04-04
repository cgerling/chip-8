defmodule Chip8.Instruction.DRWTest do
  use ExUnit.Case, async: true

  alias Chip8.Display
  alias Chip8.Instruction.Argument.Nibble
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Instruction.DRW
  alias Chip8.Memory
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with sprite at address I rendered in the display" do
      runtime = Runtime.new()
      i = :rand.uniform(0xFFF)
      runtime = put_in(runtime.i, i)
      memory = Memory.write(runtime.memory, i, [0xD9])
      runtime = put_in(runtime.memory, memory)

      vx = %Register{value: 0}
      vy = %Register{value: 0}
      nibble = %Nibble{value: 0x1}
      arguments = {vx, vy, nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      sprite_rendered_pixels = Enum.slice(executed_runtime.display.pixels, 0, 8)

      assert %Runtime{} = executed_runtime
      assert [1, 1, 0, 1, 1, 0, 0, 1] == sprite_rendered_pixels
    end

    test "should return a runtime with VF set to 0 when there was no pixel collision" do
      runtime = Runtime.new()

      vx = %Register{value: :rand.uniform(0xF)}
      vy = %Register{value: :rand.uniform(0xF)}
      nibble = %Nibble{value: :rand.uniform(0xF)}
      arguments = {vx, vy, nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end

    test "should return a runtime with VF set to 1 when there was a pixel collision" do
      runtime = Runtime.new()
      i = :rand.uniform(0xFFF)
      runtime = put_in(runtime.i, i)
      sprite_data = [0x1]
      memory = Memory.write(runtime.memory, i, sprite_data)
      runtime = put_in(runtime.memory, memory)
      sprite = Display.create_sprite(sprite_data)
      display = Display.draw(runtime.display, {0, 0}, sprite)
      runtime = put_in(runtime.display, display)

      vx = %Register{value: 0}
      vy = %Register{value: 0}
      nibble = %Nibble{value: 0x1}
      arguments = {vx, vy, nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end
  end
end
