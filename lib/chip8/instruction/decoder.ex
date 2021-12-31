defmodule Chip8.Instruction.Decoder do
  @moduledoc false

  alias Chip8.Instruction
  alias Chip8.Instruction.ADD
  alias Chip8.Instruction.AND
  alias Chip8.Instruction.CALL
  alias Chip8.Instruction.CLS
  alias Chip8.Instruction.DRW
  alias Chip8.Instruction.JP
  alias Chip8.Instruction.LD
  alias Chip8.Instruction.OR
  alias Chip8.Instruction.RET
  alias Chip8.Instruction.RND
  alias Chip8.Instruction.SE
  alias Chip8.Instruction.SHL
  alias Chip8.Instruction.SHR
  alias Chip8.Instruction.SNE
  alias Chip8.Instruction.SUB
  alias Chip8.Instruction.SUBN
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

  defp decode_data({0x1, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.new(JP, %{address: address})
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

  defp decode_data({0x6, x, byte1, byte2}) do
    byte = build_byte(byte1, byte2)

    Instruction.new(LD, %{x: x, byte: byte})
  end

  defp decode_data({0x7, x, byte1, byte2}) do
    byte = build_byte(byte1, byte2)

    Instruction.new(ADD, %{x: x, byte: byte})
  end

  defp decode_data({0x8, x, y, 0x0}) do
    Instruction.new(LD, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x1}) do
    Instruction.new(OR, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x2}) do
    Instruction.new(AND, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x3}) do
    Instruction.new(XOR, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x4}) do
    Instruction.new(ADD, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x5}) do
    Instruction.new(SUB, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x6}) do
    Instruction.new(SHR, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0x7}) do
    Instruction.new(SUBN, %{x: x, y: y})
  end

  defp decode_data({0x8, x, y, 0xE}) do
    Instruction.new(SHL, %{x: x, y: y})
  end

  defp decode_data({0x9, x, y, 0x0}) do
    Instruction.new(SNE, %{x: x, y: y})
  end

  defp decode_data({0xA, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.new(LD, %{address: address})
  end

  defp decode_data({0xB, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.new(JP, %{x: 0, address: address})
  end

  defp decode_data({0xC, x, byte1, byte2}) do
    byte = build_byte(byte1, byte2)

    Instruction.new(RND, %{x: x, byte: byte})
  end

  defp decode_data({0xD, x, y, nibble}) do
    Instruction.new(DRW, %{x: x, y: y, nibble: nibble})
  end

  defp decode_data({0xF, x, 0x1, 0xE}) do
    Instruction.new(ADD, %{x: x})
  end

  defp decode_data({0xF, x, 0x2, 0x9}) do
    Instruction.new(LD, %{x: x})
  end

  defp decode_data({0xF, x, 0x3, 0x3}) do
    Instruction.new(LD, %{x: x, operation: :bcd})
  end

  defp decode_data({0xF, x, 0x5, 0x5}) do
    Instruction.new(LD, %{x: x, operation: :store})
  end

  defp decode_data({0xF, x, 0x6, 0x5}) do
    Instruction.new(LD, %{x: x, operation: :load})
  end

  defp build_address(address1, address2, address3) do
    Integer.undigits([address1, address2, address3], @hex_base)
  end

  defp build_byte(byte1, byte2) do
    Integer.undigits([byte1, byte2], @hex_base)
  end
end
