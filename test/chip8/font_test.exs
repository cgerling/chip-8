defmodule Chip8.FontTest do
  use ExUnit.Case, async: true

  alias Chip8.Font

  describe "character_byte_size/0" do
    test "should return the size in bytes of a character" do
      character_byte_size = Font.character_byte_size()

      assert character_byte_size == 5
    end
  end
end
