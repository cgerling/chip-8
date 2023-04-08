defmodule Chip8.Interpreter.Display.SpriteTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Display.Sprite

  describe "new/1" do
    test "should return a sprite struct" do
      sprite = Sprite.new([])

      assert %Sprite{} = sprite
    end

    test "should return a sprite struct with data trimmed when data is bigger than the a sprite limit" do
      overflow_data = List.duplicate(0xFF, 20)
      sprite = Sprite.new(overflow_data)

      assert Enum.count(sprite.data) == 15
    end
  end

  describe "to_bitmap/1" do
    test "should return a matrix of bits" do
      sprite = Sprite.new([0xF0, 0xC1])

      bitmap = Sprite.to_bitmap(sprite)

      assert is_list(bitmap)
      assert Enum.all?(bitmap, &is_list/1)
    end

    test "should return a matrix of bits with the sprite data" do
      sprite = Sprite.new([0xF0, 0x9E])

      bitmap = Sprite.to_bitmap(sprite)

      assert bitmap == [
               [1, 1, 1, 1, 0, 0, 0, 0],
               [1, 0, 0, 1, 1, 1, 1, 0]
             ]
    end

    test "should return a matrix of bits with all bytes padded to a fixed width" do
      sprite = Sprite.new([0x00, 0x01])

      bitmap = Sprite.to_bitmap(sprite)

      assert bitmap == [
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 1]
             ]
    end
  end
end
