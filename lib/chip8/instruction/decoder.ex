defmodule Chip8.Instruction.Decoder do
  @moduledoc false

  alias Chip8.Instruction
  alias Chip8.Instruction.SYS
  alias Chip8.Memory

  @hex_base 16

  @spec decode(Memory.data()) :: Instruction.t()
  def decode([_byte1, _byte2] = data) do
    data
    |> parse_data()
    |> decode_data()
  end

  defp parse_data([_byte1, _byte2] = data) do
    data
    |> Enum.map(&parse_byte/1)
    |> List.flatten()
    |> List.to_tuple()
  end

  defp parse_byte(byte) when is_integer(byte) and byte in 0x0..0xFF do
    byte
    |> Integer.digits(@hex_base)
    |> pad_byte()
  end

  defp pad_byte([nibble]), do: [0x0, nibble]
  defp pad_byte([_nibble1, _nibble2] = byte), do: byte

  defp decode_data({0x0, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.new(SYS, %{address: address})
  end

  defp build_address(address1, address2, address3) do
    Integer.undigits([address1, address2, address3], @hex_base)
  end
end
