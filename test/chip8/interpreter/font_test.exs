defmodule Chip8.Interpreter.FontTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Font

  require Chip8.Interpreter.Font

  describe "is_character/1" do
    test "should return true when value is integer and between 0x0 and 0xF" do
      value = :rand.uniform(0xF)

      assert Font.is_character(value)
    end

    test "should return false when value is not an integer" do
      for invalid_value <- [0.0, %{}, {}, [], ""] do
        refute Font.is_character(invalid_value)
      end
    end

    test "should return false when value is negative" do
      negative_number = -:rand.uniform(0xF)

      refute Font.is_character(negative_number)
    end

    test "should return false when value is larger then 0xF" do
      large_integer = :rand.uniform(0xF) + 0x10

      refute Font.is_character(large_integer)
    end
  end

  describe "character_byte_size/0" do
    test "should return the size in bytes of a character" do
      character_byte_size = Font.character_byte_size()

      assert character_byte_size == 5
    end
  end

  describe "data/0" do
    test "should return all font characters as a list of bytes" do
      char_0 = [0xF0, 0x90, 0x90, 0x90, 0xF0]
      char_1 = [0x20, 0x60, 0x20, 0x20, 0x70]
      char_2 = [0xF0, 0x10, 0xF0, 0x80, 0xF0]
      char_3 = [0xF0, 0x10, 0xF0, 0x10, 0xF0]
      char_4 = [0x90, 0x90, 0xF0, 0x10, 0x10]
      char_5 = [0xF0, 0x80, 0xF0, 0x10, 0xF0]
      char_6 = [0xF0, 0x80, 0xF0, 0x90, 0xF0]
      char_7 = [0xF0, 0x10, 0x20, 0x40, 0x40]
      char_8 = [0xF0, 0x90, 0xF0, 0x90, 0xF0]
      char_9 = [0xF0, 0x90, 0xF0, 0x10, 0xF0]
      char_a = [0xF0, 0x90, 0xF0, 0x90, 0x90]
      char_b = [0xE0, 0x90, 0xE0, 0x90, 0xE0]
      char_c = [0xF0, 0x80, 0x80, 0x80, 0xF0]
      char_d = [0xE0, 0x90, 0x90, 0x90, 0xE0]
      char_e = [0xF0, 0x80, 0xF0, 0x80, 0xF0]
      char_f = [0xF0, 0x80, 0xF0, 0x80, 0x80]

      font_data =
        List.flatten([
          char_0,
          char_1,
          char_2,
          char_3,
          char_4,
          char_5,
          char_6,
          char_7,
          char_8,
          char_9,
          char_a,
          char_b,
          char_c,
          char_d,
          char_e,
          char_f
        ])

      data = Font.data()

      assert font_data == data
    end
  end
end
