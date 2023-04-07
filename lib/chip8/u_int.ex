defmodule Chip8.UInt do
  @moduledoc false

  @type uint8() :: 0x0..0xFF
  @type uint12() :: 0x0..0xFFF
  @type uint16() :: 0x0..0xFFFF

  @spec to_uint8(integer()) :: uint8()
  def to_uint8(integer) when is_integer(integer) do
    to_uint(integer, 8)
  end

  @spec to_uint12(integer()) :: uint12()
  def to_uint12(integer) when is_integer(integer) do
    to_uint(integer, 12)
  end

  @spec to_uint16(integer()) :: uint16()
  def to_uint16(integer) when is_integer(integer) do
    to_uint(integer, 16)
  end

  defp to_uint(integer, bit_size)
       when is_integer(integer) and is_integer(bit_size) and bit_size > 0 do
    max_value = Bitwise.bsl(1, bit_size) - 1
    Bitwise.band(integer, max_value)
  end
end
