defmodule Chip8.UIntTest do
  use ExUnit.Case, async: true

  alias Chip8.UInt

  describe "to_uint8/1" do
    @max_size 255

    test "should return an positive integer with max size of 8 bits" do
      integer = :rand.uniform(@max_size)

      uint8 = UInt.to_uint8(integer)

      assert uint8 == integer
    end

    test "should return an positive integer with max size of 8 bits when given integer is greater than 8 bits" do
      integer = :rand.uniform(@max_size)
      overflown_integer = @max_size + integer

      uint8 = UInt.to_uint8(overflown_integer)

      assert uint8 == integer - 1
    end

    test "should return an positive integer with max size of 8 bits when given integer is negative" do
      integer = :rand.uniform(@max_size)
      negative_integer = integer * -1

      uint8 = UInt.to_uint8(negative_integer)

      assert uint8 == @max_size - integer + 1
    end
  end

  describe "to_uint12/1" do
    @max_size 4095

    test "should return an positive integer with max size of 12 bits" do
      integer = :rand.uniform(@max_size)

      uint12 = UInt.to_uint12(integer)

      assert uint12 == integer
    end

    test "should return an positive integer with max size of 12 bits when given integer is greater than 12 bits" do
      integer = :rand.uniform(@max_size)
      overflown_integer = @max_size + integer

      uint12 = UInt.to_uint12(overflown_integer)

      assert uint12 == integer - 1
    end

    test "should return an positive integer with max size of 12 bits when given integer is negative" do
      integer = :rand.uniform(@max_size)
      negative_integer = integer * -1

      uint12 = UInt.to_uint12(negative_integer)

      assert uint12 == @max_size - integer + 1
    end
  end

  describe "to_uint16/1" do
    @max_size 65_535

    test "should return an positive integer with max size of 16 bits" do
      integer = :rand.uniform(@max_size)

      uint16 = UInt.to_uint16(integer)

      assert uint16 == integer
    end

    test "should return an positive integer with max size of 16 bits when given integer is greater than 16 bits" do
      integer = :rand.uniform(@max_size)
      overflown_integer = @max_size + integer

      uint16 = UInt.to_uint16(overflown_integer)

      assert uint16 == integer - 1
    end

    test "should return an positive integer with max size of 16 bits when given integer is negative" do
      integer = :rand.uniform(@max_size)
      negative_integer = integer * -1

      uint16 = UInt.to_uint16(negative_integer)

      assert uint16 == @max_size - integer + 1
    end
  end
end
