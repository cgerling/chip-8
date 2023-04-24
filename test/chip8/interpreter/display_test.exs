defmodule Chip8.Interpreter.DisplayTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Display.Coordinates
  alias Chip8.Interpreter.Display.Sprite

  describe "new/2" do
    test "should return a display struct with the given dimensions" do
      display = Display.new(10, 20)

      assert %Display{} = display
      assert display.height == 10
      assert display.width == 20
    end
  end

  describe "clear/1" do
    test "should return a display struct with all pixels off" do
      sprite = 0xFF |> List.duplicate(15) |> Sprite.new()
      coordinates = Coordinates.new(0, 0)

      display = Display.new(10, 10)
      {display, _} = Display.draw(display, coordinates, sprite)

      cleared_display = Display.clear(display)

      assert %Display{} = cleared_display
      assert display.height == cleared_display.height
      assert display.width == cleared_display.width
      refute Display.pixelmap(display) == Display.pixelmap(cleared_display)

      assert Display.pixelmap(cleared_display) == [
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
             ]
    end
  end

  describe "get_coordinates/3" do
    test "should return a coordinates tuple from x and y values" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = :rand.uniform(display.height - 1)

      coordinates = Display.get_coordinates(display, x, y)

      assert Coordinates.new(x, y) == coordinates
    end

    test "should return a coordinates tuple wrapped when x is equals to display's width" do
      display = Display.new(50, 100)
      x = display.width
      y = :rand.uniform(display.height - 1)

      coordinates = Display.get_coordinates(display, x, y)

      assert Coordinates.new(0, y) == coordinates
    end

    test "should return a coordinates tuple wrapped when x is greather than display's width" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = :rand.uniform(display.height - 1)

      overflow_x = display.width + x

      coordinates = Display.get_coordinates(display, overflow_x, y)

      assert Coordinates.new(x, y) == coordinates
    end

    test "should return a coordinates tuple wrapped when y is equals to display's height" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = display.height

      coordinates = Display.get_coordinates(display, x, y)

      assert Coordinates.new(x, 0) == coordinates
    end

    test "should return a coordinates tuple wrapped when y is greather than display's height" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = :rand.uniform(display.height - 1)

      overflow_y = display.height + y

      coordinates = Display.get_coordinates(display, x, overflow_y)

      assert Coordinates.new(x, y) == coordinates
    end
  end

  describe "draw/3" do
    test "should return a display struct with sprite rendered into the given coordinates" do
      display = Display.new(8, 8)
      sprite = Sprite.new([0xAA, 0x55, 0xAA, 0x55])
      coordinates = Coordinates.new(0, 2)

      {drawed_display, _collision} = Display.draw(display, coordinates, sprite)

      assert %Display{} = drawed_display

      assert Display.pixelmap(drawed_display) == [
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [1, 0, 1, 0, 1, 0, 1, 0],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [1, 0, 1, 0, 1, 0, 1, 0],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0]
             ]
    end

    test "should return a display struct with the sprite erased when rendered twice into the same coordinates" do
      display = Display.new(8, 8)
      sprite = Sprite.new([0xAA, 0x55, 0xAA, 0x55])
      coordinates = Coordinates.new(0, 2)

      {display, _collision} = Display.draw(display, coordinates, sprite)

      {drawed_display, _collision} = Display.draw(display, coordinates, sprite)

      assert %Display{} = drawed_display

      assert Display.pixelmap(drawed_display) == [
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0]
             ]
    end

    test "should return a display struct with the sprite cropped horizontally when it overflows the display's width" do
      display = Display.new(8, 8)
      sprite = Sprite.new([0xFF, 0xFF])
      coordinates = Coordinates.new(4, 0)

      {drawed_display, _collision} = Display.draw(display, coordinates, sprite)

      assert %Display{} = drawed_display

      assert Display.pixelmap(drawed_display) == [
               [0, 0, 0, 0, 1, 1, 1, 1],
               [0, 0, 0, 0, 1, 1, 1, 1],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0]
             ]
    end

    test "should return a display struct with the sprite cropped vertically when it overflows the display's height" do
      display = Display.new(8, 8)
      sprite = Sprite.new([0x0F, 0x0F, 0x0F, 0x0F])
      coordinates = Coordinates.new(0, 6)

      {drawed_display, _collision} = Display.draw(display, coordinates, sprite)

      assert %Display{} = drawed_display

      assert Display.pixelmap(drawed_display) == [
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 1, 1, 1, 1],
               [0, 0, 0, 0, 1, 1, 1, 1]
             ]
    end

    test "should return collision flag as true when one of the display pixels was turned off while drawing the sprite" do
      display = Display.new(8, 8)
      coordinates = Coordinates.new(0, 0)
      sprite = Sprite.new([0x1])

      {drawed_display, _collision} = Display.draw(display, coordinates, sprite)
      assert {_display, true} = Display.draw(drawed_display, coordinates, sprite)
    end

    test "should return collision flag as false when no one of the display pixels was turned off while drawing the sprite" do
      display = Display.new(8, 8)
      coordinates = Coordinates.new(0, 0)
      sprite = Sprite.new([0x1])

      assert {_display, false} = Display.draw(display, coordinates, sprite)
    end
  end

  describe "create_sprite/1" do
    test "should return a sprite struct" do
      sprite = Sprite.new([])

      assert %Sprite{} = sprite
    end
  end

  describe "pixelmap/1" do
    test "should return a list with the pixel content of the display" do
      display = Display.new(8, 8)

      pixelmap = Display.pixelmap(display)

      assert pixelmap == [
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0]
             ]
    end
  end

  describe "diff/2" do
    test "should return a list with coordinates and the state of all pixels on the second display that has a different state from their equivalent ones on the first display" do
      display = Display.new(8, 8)
      sprite = Sprite.new([0x05, 0x05])
      coordinates = Coordinates.new(0, 0)

      {drawed_display, _} = Display.draw(display, coordinates, sprite)

      diff_pixels = Display.diff(display, drawed_display)
      assert Enum.sort(diff_pixels) == [{{5, 0}, 1}, {{5, 1}, 1}, {{7, 0}, 1}, {{7, 1}, 1}]
    end

    test "should return an empty list when there is no difference between the pixel's state between the first display and the second display" do
      display = Display.new(8, 8)

      assert Display.diff(display, display) == []
    end
  end
end
