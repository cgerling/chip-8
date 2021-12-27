defmodule Chip8.DisplayTest do
  use ExUnit.Case, async: true

  alias Chip8.Display

  describe "new/2" do
    test "should return a display struct" do
      display = Display.new(10, 10)

      assert %Display{} = display
    end

    test "should return a display with the given dimensions" do
      display = Display.new(10, 20)

      assert display.height == 10
      assert display.width == 20
    end
  end

  describe "clear/1" do
    test "should return a display struct" do
      display = Display.new(10, 10)

      cleared_display = Display.clear(display)

      assert %Display{} = cleared_display
    end

    test "should return a display with all pixels off" do
      display = Display.new(10, 10)
      filled_pixels = List.duplicate(1, display.height * display.width)
      display = %{display | pixels: filled_pixels}

      cleared_display = Display.clear(display)

      assert display.height == cleared_display.height
      assert display.width == cleared_display.width
      assert Enum.all?(cleared_display.pixels, &(&1 == 0))
    end
  end
end
