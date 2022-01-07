defmodule Chip8.UInt do
  @moduledoc false

  @spec to_uint8(integer()) :: non_neg_integer()
  def to_uint8(integer) when is_integer(integer) do
    to_uint(integer, 8)
  end

  @spec to_uint12(integer()) :: non_neg_integer()
  def to_uint12(integer) when is_integer(integer) do
    to_uint(integer, 12)
  end

  @spec to_uint16(integer()) :: non_neg_integer()
  def to_uint16(integer) when is_integer(integer) do
    to_uint(integer, 16)
  end

  defp to_uint(integer, bit_size)
       when is_integer(integer) and is_integer(bit_size) and bit_size > 0 do
    max_value = Bitwise.bsl(1, bit_size) - 1
    Bitwise.band(integer, max_value)
  end
end
