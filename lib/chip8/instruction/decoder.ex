defmodule Chip8.Instruction.Decoder do
  @moduledoc false

  alias Chip8.Instruction
  alias Chip8.Instruction.AND
  alias Chip8.Instruction.CALL
  alias Chip8.Instruction.CLS
  alias Chip8.Instruction.DRW
  alias Chip8.Instruction.OR
  alias Chip8.Instruction.RET
  alias Chip8.Instruction.SE
  alias Chip8.Instruction.SNE
  alias Chip8.Instruction.SYS
  alias Chip8.Instruction.XOR
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

  defp decode_data({0x0, 0x0, 0xE, 0x0}) do
    Instruction.new(CLS)
  end

  defp decode_data({0x0, 0x0, 0xE, 0xE}) do
    Instruction.new(RET)
  end

  defp decode_data({0x0, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.new(SYS, %{address: address})
  end

  defp decode_data({0x2, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.new(CALL, %{address: address})
  end

  defp decode_data({0x3, x, byte1, byte2}) do
    byte = build_byte(byte1, byte2)

    Instruction.new(SE, %{x: x, byte: byte})
  end

  defp decode_data({0x4, x, byte1, byte2}) do
    byte = build_byte(byte1, byte2)

    Instruction.new(SNE, %{x: x, byte: byte})
  end

  defp decode_data({0x5, x, y, 0x0}) do
    Instruction.new(SE, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 1}) do
    Instruction.new(OR, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 2}) do
    Instruction.new(AND, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 3}) do
    Instruction.new(XOR, %{x: x, y: y})
  end

  defp decode_data({0x9, x, y, 0x0}) do
    Instruction.new(SNE, %{x: x, y: y})
  end

  defp decode_data({0xD, x, y, nibble}) do
    Instruction.new(DRW, %{x: x, y: y, nibble: nibble})
  end

  defp build_address(address1, address2, address3) do
    Integer.undigits([address1, address2, address3], @hex_base)
  end

  defp build_byte(byte1, byte2) do
    Integer.undigits([byte1, byte2], @hex_base)
  end
end
