defmodule Chip8.SpriteTest do
  use ExUnit.Case, async: true

  alias Chip8.Sprite

  describe "new/1" do
    test "should return a sprite struct" do
      sprite = Sprite.new([])

      assert %Sprite{} = sprite
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
