defmodule Chip8.Hex do
  @moduledoc false

  @base 16

  @spec digits(integer(), Keyword.t()) :: list(integer())
  def digits(number, opts \\ []) when is_integer(number) do
    digits = Integer.digits(number, @base)

    count = Enum.count(digits)
    size = Keyword.get(opts, :size, count)

    padding_size = max(size - count, 0)
    padding = List.duplicate(0x0, padding_size)

    List.flatten([padding | digits])
  end

  @spec from_digits(list(integer())) :: integer()
  def from_digits(digits) when is_list(digits) do
    Integer.undigits(digits, @base)
  end

  @spec to_string(integer()) :: String.t()
  def to_string(number) when is_integer(number) do
    Integer.to_string(number, @base)
  end

  @spec from_string(String.t()) :: integer()
  def from_string(string) when is_binary(string) do
    String.to_integer(string, @base)
  end
end
