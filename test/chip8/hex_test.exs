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
end
