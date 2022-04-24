defmodule Chip8.Interpreter.Instruction.CLSTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Instruction.CLS

  describe "execute/2" do
    test "should return an interpreter with the display clear" do
      interpreter = Interpreter.new()
      display_height = interpreter.display.height
      display_width = interpreter.display.width
      filled_pixels = List.duplicate(1, display_height * display_width)
      interpreter = put_in(interpreter.display.pixels, filled_pixels)

      empty_display = Display.new(display_height, display_width)

      arguments = {}
      executed_interpreter = CLS.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert empty_display == executed_interpreter.display
    end
  end
end
