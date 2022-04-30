defmodule Chip8.Interpreter.DisplayTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Display
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
      display = Display.new(10, 10)
      filled_pixels = List.duplicate(1, display.height * display.width)
      display = %{display | pixels: filled_pixels}

      cleared_display = Display.clear(display)

      assert %Display{} = cleared_display
      assert display.height == cleared_display.height
      assert display.width == cleared_display.width
      assert Enum.all?(cleared_display.pixels, &(&1 == 0))
    end
  end

  describe "get_coordinates/3" do
    test "should return a coordinates tuple from x and y values" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = :rand.uniform(display.height - 1)

      coordinates = Display.get_coordinates(display, x, y)

      assert {x, y} == coordinates
    end

    test "should return a coordinates tuple wrapped when x is equals to display's width" do
      display = Display.new(50, 100)
      x = display.width
      y = :rand.uniform(display.height - 1)

      coordinates = Display.get_coordinates(display, x, y)

      assert {0, y} == coordinates
    end

    test "should return a coordinates tuple wrapped when x is greather than display's width" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = :rand.uniform(display.height - 1)

      overflow_x = display.width + x

      coordinates = Display.get_coordinates(display, overflow_x, y)

      assert {x, y} == coordinates
    end

    test "should return a coordinates tuple wrapped when y is equals to display's height" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = display.height

      coordinates = Display.get_coordinates(display, x, y)

      assert {x, 0} == coordinates
    end

    test "should return a coordinates tuple wrapped when y is greather than display's height" do
      display = Display.new(50, 100)
      x = :rand.uniform(display.width - 1)
      y = :rand.uniform(display.height - 1)

      overflow_y = display.height + y

      coordinates = Display.get_coordinates(display, x, overflow_y)

      assert {x, y} == coordinates
    end
  end

  describe "draw/3" do
    test "should return a display struct with sprite rendered into the given coordinates" do
      display = Display.new(8, 8)
      sprite = Sprite.new([0xAA, 0x55, 0xAA, 0x55])
      coordinates = {0, 2}

      drawed_display = Display.draw(display, coordinates, sprite)

      display_matrix = Enum.chunk_every(drawed_display.pixels, display.width)

      assert %Display{} = drawed_display
      assert 16 == Enum.count(drawed_display.pixels, &(&1 == 1))

      assert display_matrix == [
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
      coordinates = {0, 2}

      display = Display.draw(display, coordinates, sprite)

      drawed_display = Display.draw(display, coordinates, sprite)

      display_matrix = Enum.chunk_every(drawed_display.pixels, display.width)

      assert %Display{} = drawed_display
      assert Enum.all?(drawed_display.pixels, &(&1 == 0))

      assert display_matrix == [
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
      coordinates = {4, 0}

      drawed_display = Display.draw(display, coordinates, sprite)

      display_matrix = Enum.chunk_every(drawed_display.pixels, display.width)

      assert %Display{} = drawed_display
      assert 8 == Enum.count(drawed_display.pixels, &(&1 == 1))

      assert display_matrix == [
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
      coordinates = {0, 6}

      drawed_display = Display.draw(display, coordinates, sprite)

      display_matrix = Enum.chunk_every(drawed_display.pixels, display.width)

      assert %Display{} = drawed_display
      assert 8 == Enum.count(drawed_display.pixels, &(&1 == 1))

      assert display_matrix == [
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
  end

  describe "has_collision?/2" do
    test "should return true when any of the pixels on in the before display are off in the after display" do
      display = Display.new(8, 8)
      coordinates = {0, 0}
      sprite = Sprite.new([0x1])

      before_display = Display.draw(display, coordinates, sprite)
      after_display = Display.draw(before_display, coordinates, sprite)

      has_collision? = Display.has_collision?(before_display, after_display)

      assert has_collision?
    end

    test "should return false when all of the pixels on in the before display are still on in the after display" do
      before_display = Display.new(8, 8)
      after_display = Display.new(8, 8)

      has_collision? = Display.has_collision?(before_display, after_display)

      refute has_collision?
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
end
