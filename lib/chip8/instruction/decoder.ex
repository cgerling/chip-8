defmodule Chip8.Instruction.Decoder do
  @moduledoc false

  alias Chip8.Instruction
  alias Chip8.Instruction.Argument.Address
  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Nibble
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Memory

  @hex_base 16

  @spec decode(Memory.data()) :: Instruction.t()
  def decode([byte1, byte2] = data)
      when is_integer(byte1) and is_integer(byte2) and byte1 in 0x00..0xFF and byte2 in 0x00..0xFF do
    data
    |> parse_data()
    |> decode_data()
  end

  defp parse_data([_, _] = data) do
    data
    |> Enum.map(&parse_byte/1)
    |> List.flatten()
    |> List.to_tuple()
  end

  defp parse_byte(byte) do
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
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.SHL.new({vx, vy})
  end

  defp decode_data({0x9, x, y, 0x0}) do
    vx = Register.v(x)
    vy = Register.v(y)

    Instruction.SNE.new({vx, vy})
  end

  defp decode_data({0xA, address1, address2, address3}) do
    i = Register.i()
    address = Address.new(address1, address2, address3)

    Instruction.LD.new({i, address})
  end

  defp decode_data({0xB, address1, address2, address3}) do
    v0 = Register.v(0)
    address = Address.new(address1, address2, address3)

    Instruction.JP.new({v0, address})
  end

  defp decode_data({0xC, x, byte1, byte2}) do
    vx = Register.v(x)
    byte = Byte.new(byte1, byte2)

    Instruction.RND.new({vx, byte})
  end

  defp decode_data({0xD, x, y, nibble}) do
    vx = Register.v(x)
    vy = Register.v(y)
    nibble = Nibble.new(nibble)

    Instruction.DRW.new({vx, vy, nibble})
  end

  defp decode_data({0xE, x, 0x9, 0xE}) do
    vx = Register.v(x)

    Instruction.SKP.new({vx})
  end

  defp decode_data({0xE, x, 0xA, 0x1}) do
    vx = Register.v(x)

    Instruction.SKNP.new({vx})
  end

  defp decode_data({0xF, x, 0x0, 0x7}) do
    vx = Register.v(x)
    dt = Register.dt()

    Instruction.LD.new({vx, dt})
  end

  defp decode_data({0xF, x, 0x0, 0xA}) do
    vx = Register.v(x)
    keyboard = Register.keyboard()

    Instruction.LD.new({vx, keyboard})
  end

  defp decode_data({0xF, x, 0x1, 0x5}) do
    dt = Register.dt()
    vx = Register.v(x)

    Instruction.LD.new({dt, vx})
  end

  defp decode_data({0xF, x, 0x1, 0x8}) do
    st = Register.st()
    vx = Register.v(x)

    Instruction.LD.new({st, vx})
  end

  defp decode_data({0xF, x, 0x1, 0xE}) do
    i = Register.i()
    vx = Register.v(x)

    Instruction.ADD.new({i, vx})
  end

  defp decode_data({0xF, x, 0x2, 0x9}) do
    font = Register.font()
    vx = Register.v(x)

    Instruction.LD.new({font, vx})
  end

  defp decode_data({0xF, x, 0x3, 0x3}) do
    bcd = Register.bcd()
    vx = Register.v(x)

    Instruction.LD.new({bcd, vx})
  end

  defp decode_data({0xF, x, 0x5, 0x5}) do
    memory = Register.memory()
    vx = Register.v(x)

    Instruction.LD.new({memory, vx})
  end

  defp decode_data({0xF, x, 0x6, 0x5}) do
    vx = Register.v(x)
    memory = Register.memory()

    Instruction.LD.new({vx, memory})
  end
end
