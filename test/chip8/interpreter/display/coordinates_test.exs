defmodule Chip8.Interpreter.Display.CoordinatesTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Display.Coordinates

  describe "new/1" do
    test "should return a coordinates struct" do
      x = :rand.uniform(1000)
      y = :rand.uniform(1000)
      coordinates = Coordinates.new(x, y)

      assert %Coordinates{} = coordinates
      assert coordinates.x == x
      assert coordinates.y == y
    end
  end

  describe "add/2" do
    test "should return a coordinates struct with both axis added up" do
      x_a = :rand.uniform(1000)
      y_a = :rand.uniform(1000)
      coordinates_a = Coordinates.new(x_a, y_a)

      x_b = :rand.uniform(1000)
      y_b = :rand.uniform(1000)
      coordinates_b = Coordinates.new(x_b, y_b)

      coordinates = Coordinates.add(coordinates_a, coordinates_b)
      assert %Coordinates{} = coordinates
      assert coordinates.x == x_a + x_b
      assert coordinates.y == y_a + y_b
    end
  end

  describe "from_ordinal/2" do
    test "should return a coordinates struct based in the given ordinal" do
      ordinal = 8
      max_y = 20

      assert Coordinates.from_ordinal(ordinal, max_y) == Coordinates.new(8, 0)
    end

    test "should return a coordinates struct when ordinal is greater than the given maximum y value" do
      ordinal = 35
      max_y = 20

      assert Coordinates.from_ordinal(ordinal, max_y) == Coordinates.new(15, 1)
    end
  end
end
