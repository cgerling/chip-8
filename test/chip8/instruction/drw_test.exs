defmodule Chip8.Instruction.DRWTest do
  use ExUnit.Case, async: true

  alias Chip8.Display
  alias Chip8.Instruction.DRW
  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.Sprite

  describe "execute/2" do
    test "should return a runtime with sprite at address I rendered in the display" do
      runtime = Runtime.new()
      i = :rand.uniform(0xFFF)
      runtime = put_in(runtime.i, i)
      memory = Memory.write(runtime.memory, i, [0xD9])
      runtime = put_in(runtime.memory, memory)

      x = 0
      y = 0
      nibble = 0x1
      arguments = %{x: x, y: y, nibble: nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      sprite_rendered_pixels = Enum.slice(executed_runtime.display.pixels, 0, 8)

      assert %Runtime{} = executed_runtime
      assert [1, 1, 0, 1, 1, 0, 0, 1] == sprite_rendered_pixels
    end

    test "should return a runtime with VF set to 0 when there was no pixel collision" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      y = :rand.uniform(0xF)
      nibble = :rand.uniform(0xF)
      arguments = %{x: x, y: y, nibble: nibble}
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
      sprite = Sprite.new(sprite_data)
      display = Display.draw(runtime.display, {0, 0}, sprite)
      runtime = put_in(runtime.display, display)

      x = 0
      y = 0
      nibble = 0x1
      arguments = %{x: x, y: y, nibble: nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end
  end
end
