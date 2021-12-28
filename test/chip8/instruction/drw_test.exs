defmodule Chip8.Instruction.DRWTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.DRW
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      y = :rand.uniform(0xF)
      nibble = :rand.uniform(0xF)

      arguments = %{x: x, y: y, nibble: nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with sprite at address I rendered in the display" do
      runtime = Runtime.new()
      i = :rand.uniform(0xFFF)
      memory_data = List.replace_at(runtime.memory.data, i, 0xD9)
      runtime = put_in(runtime.i, i)
      runtime = put_in(runtime.memory.data, memory_data)

      x = 0
      y = 0
      nibble = 0x1

      arguments = %{x: x, y: y, nibble: nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      sprite_rendered_pixels = Enum.slice(executed_runtime.display.pixels, 0, 8)

      assert [1, 1, 0, 1, 1, 0, 0, 1] == sprite_rendered_pixels
    end

    test "should return a runtime with VF set to 0 when there was no pixel collision" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      y = :rand.uniform(0xF)
      nibble = :rand.uniform(0xF)

      arguments = %{x: x, y: y, nibble: nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      vf = VRegisters.get(executed_runtime.v, 0xF)

      assert 0 == vf
    end

    test "should return a runtime with VF set to 1 when there was a pixel collision" do
      runtime = Runtime.new()
      i = :rand.uniform(0xFFF)
      memory_data = List.replace_at(runtime.memory.data, i, 0xA0)
      display_pixels = List.replace_at(runtime.display.pixels, 0, 1)
      runtime = put_in(runtime.i, i)
      runtime = put_in(runtime.memory.data, memory_data)
      runtime = put_in(runtime.display.pixels, display_pixels)

      x = 0
      y = 0
      nibble = 0x1

      arguments = %{x: x, y: y, nibble: nibble}
      executed_runtime = DRW.execute(runtime, arguments)

      vf = VRegisters.get(executed_runtime.v, 0xF)

      assert 1 == vf
    end
  end
end
