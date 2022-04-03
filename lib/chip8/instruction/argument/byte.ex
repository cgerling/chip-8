defmodule Chip8.Instruction.Argument.Byte do
  @moduledoc false

  alias Chip8.Hex

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type value_range :: 0x00..0xFF

  @type t :: %__MODULE__{
          value: value_range()
        }

  @spec new(0x0..0xF, 0x0..0xF) :: t()
  def new(byte1, byte2)
      when is_integer(byte1) and is_integer(byte2) and byte1 in 0x0..0xF and byte2 in 0x0..0xF do
    [byte1, byte2]
    |> Hex.from_digits()
    |> new()
  end

  @spec new(value_range()) :: t()
  def new(value) when is_integer(value) and value in 0x00..0xFF do
    %__MODULE__{
      value: value
    }
  end
end
