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
end
