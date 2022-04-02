defmodule Chip8.Instruction.Decoder do
  @moduledoc false

  alias Chip8.Instruction
  alias Chip8.Instruction.Argument.Address
  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Register
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
    Instruction.CLS.new({})
  end

  defp decode_data({0x0, 0x0, 0xE, 0xE}) do
    Instruction.RET.new({})
  end

  defp decode_data({0x0, address1, address2, address3}) do
    address = Address.new(address1, address2, address3)

    Instruction.SYS.new({address})
  end

  defp decode_data({0x1, address1, address2, address3}) do
    address = Address.new(address1, address2, address3)

    Instruction.JP.new({address})
  end

  defp decode_data({0x2, address1, address2, address3}) do
    address = Address.new(address1, address2, address3)

    Instruction.CALL.new({address})
  end

  defp decode_data({0x3, x, byte1, byte2}) do
    vx = Register.v(x)
    byte = Byte.new(byte1, byte2)

    Instruction.SE.new({vx, byte})
  end

  defp decode_data({0x4, x, byte1, byte2}) do
    vx = Register.v(x)
    byte = Byte.new(byte1, byte2)

    Instruction.SNE.new({vx, byte})
  end

  defp decode_data({0x5, x, y, 0x0}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.SE.new({vx, vy})
  end

  defp decode_data({0x6, x, byte1, byte2}) do
    vx = Register.v(x)
    byte = Byte.new(byte1, byte2)

    Instruction.LD.new({vx, byte})
  end

  defp decode_data({0x7, x, byte1, byte2}) do
    vx = Register.v(x)
    byte = Byte.new(byte1, byte2)

    Instruction.ADD.new({vx, byte})
  end

  defp decode_data({0x8, x, y, 0x0}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.LD.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x1}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.OR.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x2}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.AND.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x3}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.XOR.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x4}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.ADD.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x5}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.SUB.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x6}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.SHR.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0x7}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.SUBN.new({vx, vy})
  end

  defp decode_data({0x8, x, y, 0xE}) do
    Instruction.SHL.new(%{x: x, y: y})
  end

  defp decode_data({0x9, x, y, 0x0}) do
    Instruction.SNE.new(%{x: x, y: y})
  end

  defp decode_data({0xA, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.LD.new(%{address: address})
  end

  defp decode_data({0xB, address1, address2, address3}) do
    address = build_address(address1, address2, address3)

    Instruction.JP.new(%{x: 0, address: address})
  end

  defp decode_data({0xC, x, byte1, byte2}) do
    byte = build_byte(byte1, byte2)

    Instruction.RND.new(%{x: x, byte: byte})
  end

  defp decode_data({0xD, x, y, nibble}) do
    Instruction.DRW.new(%{x: x, y: y, nibble: nibble})
  end

  defp decode_data({0xE, x, 0x9, 0xE}) do
    Instruction.SKP.new(%{x: x})
  end

  defp decode_data({0xE, x, 0xA, 0x1}) do
    Instruction.SKNP.new(%{x: x})
  end

  defp decode_data({0xF, x, 0x0, 0x7}) do
    Instruction.LD.new(%{x: x, y: :dt})
  end

  defp decode_data({0xF, x, 0x0, 0xA}) do
    Instruction.LD.new(%{x: x, y: :keyboard})
  end

  defp decode_data({0xF, y, 0x1, 0x5}) do
    Instruction.LD.new(%{x: :dt, y: y})
  end

  defp decode_data({0xF, y, 0x1, 0x8}) do
    Instruction.LD.new(%{x: :st, y: y})
  end

  defp decode_data({0xF, y, 0x1, 0xE}) do
    Instruction.ADD.new(%{x: :i, y: y})
  end

  defp decode_data({0xF, y, 0x2, 0x9}) do
    Instruction.LD.new(%{x: :font, y: y})
  end

  defp decode_data({0xF, y, 0x3, 0x3}) do
    Instruction.LD.new(%{x: :bcd, y: y})
  end

  defp decode_data({0xF, y, 0x5, 0x5}) do
    Instruction.LD.new(%{x: :memory, y: y})
  end

  defp decode_data({0xF, x, 0x6, 0x5}) do
    Instruction.LD.new(%{x: x, y: :memory})
  end

  defp build_address(address1, address2, address3) do
    Integer.undigits([address1, address2, address3], @hex_base)
  end

  defp build_byte(byte1, byte2) do
    Integer.undigits([byte1, byte2], @hex_base)
  end
end
