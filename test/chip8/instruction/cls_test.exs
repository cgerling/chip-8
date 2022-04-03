defmodule Chip8.Instruction.CLSTest do
  use ExUnit.Case, async: true

  alias Chip8.Display
  alias Chip8.Instruction.CLS
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with the display clear" do
      runtime = Runtime.new()
      display_height = runtime.display.height
      display_width = runtime.display.width
      filled_pixels = List.duplicate(1, display_height * display_width)
      runtime = put_in(runtime.display.pixels, filled_pixels)

      empty_display = Display.new(display_height, display_width)

      arguments = {}
      executed_runtime = CLS.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert empty_display == executed_runtime.display
    end
  end
end
