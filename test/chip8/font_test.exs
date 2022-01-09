defmodule Chip8.FontTest do
  use ExUnit.Case, async: true

  alias Chip8.Font

  describe "address/1" do
    test "should return the memory address for all characters" do
      characters_with_address = [
        {0x0, 0x050},
        {0x1, 0x055},
        {0x2, 0x05A},
        {0x3, 0x05F},
        {0x4, 0x064},
        {0x5, 0x069},
        {0x6, 0x06E},
        {0x7, 0x073},
        {0x8, 0x078},
        {0x9, 0x07D},
        {0xA, 0x082},
        {0xB, 0x087},
        {0xC, 0x08C},
        {0xD, 0x091},
        {0xE, 0x096},
        {0xF, 0x09B}
      ]

      for {character, character_address} <- characters_with_address do
        address = Font.address(character)

        assert is_integer(address)
        assert character_address == address
      end
    end
  end

  describe "character_byte_size/0" do
    test "should return the size in bytes of a character" do
      character_byte_size = Font.character_byte_size()

      assert character_byte_size == 5
    end
  end
end
