defmodule Chip8.Font do
  @moduledoc false

  @base_address 0x050
  @byte_size 5

  @spec address(0x0..0xF) :: non_neg_integer()
  def address(character) when is_integer(character) and character in 0x0..0xF,
    do: @base_address + @byte_size * character

  @spec character_byte_size() :: pos_integer()
  def character_byte_size, do: 5
end
