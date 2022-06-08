defmodule Chip8.HexTest do
  use ExUnit.Case, async: true

  alias Chip8.Hex

  describe "digits/1" do
    test "should return a list with the number digits" do
      number = 0xFEDCBA098

      digits = Hex.digits(number)

      assert digits == [0xF, 0xE, 0xD, 0xC, 0xB, 0xA, 0x0, 0x9, 0x8]
    end

    test "should return a list without padding of zeroes when the given number's digit count is greather than the given size" do
      number = 0xABCD

      digits = Hex.digits(number, size: 2)

      assert digits == [0xA, 0xB, 0xC, 0xD]
    end

    test "should return a list without padding of zeroes when the given number's digit count is equals to the given size" do
      number = 0xABCD

      digits = Hex.digits(number, size: 4)

      assert digits == [0xA, 0xB, 0xC, 0xD]
    end

    test "should return a list with padding of zeroes when the given number's digit count is less than the given size" do
      number = 0xABCD

      digits = Hex.digits(number, size: 8)

      assert digits == [0x0, 0x0, 0x0, 0x0, 0xA, 0xB, 0xC, 0xD]
    end
  end

  describe "from_digits/1" do
    test "should return an hexadecimal integer with the given digits" do
      digits = [0xF, 0xE, 0xD, 0xC, 0xB, 0xA, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0]

      number = Hex.from_digits(digits)

      assert number == 0xFEDCBA9876543210
    end
  end

  describe "to_string/1" do
    test "should return an string representing an hexadecimal number" do
      numbers = [
        {0, "0"},
        {1, "1"},
        {2, "2"},
        {3, "3"},
        {4, "4"},
        {5, "5"},
        {6, "6"},
        {7, "7"},
        {8, "8"},
        {9, "9"},
        {10, "A"},
        {11, "B"},
        {12, "C"},
        {13, "D"},
        {14, "E"},
        {15, "F"}
      ]

      for {number, string} <- numbers do
        hex_string = Hex.to_string(number)

        assert hex_string == string
      end
    end
  end

  describe "from_string/1" do
    test "should return an integer from a string representing an hexadecimal number" do
      numbers = [
        {"0", 0},
        {"1", 1},
        {"2", 2},
        {"3", 3},
        {"4", 4},
        {"5", 5},
        {"6", 6},
        {"7", 7},
        {"8", 8},
        {"9", 9},
        {"A", 10},
        {"B", 11},
        {"C", 12},
        {"D", 13},
        {"E", 14},
        {"F", 15}
      ]

      for {string, number} <- numbers do
        hex_number = Hex.from_string(string)

        assert hex_number == number
      end
    end
  end
end
