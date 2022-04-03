defmodule Chip8.Instruction.Argument.Address do
  @moduledoc false

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type value_range :: 0x000..0xFFF

  @type t :: %__MODULE__{
          value: value_range()
        }

  @spec new(0x0..0xF, 0x0..0xF, 0x0..0xF) :: t()
  def new(address1, address2, address3)
      when is_integer(address1) and is_integer(address2) and is_integer(address3) and
             address1 in 0x0..0xF and address2 in 0x0..0xF and address3 in 0x0..0xF do
    [address1, address2, address3]
    |> Integer.undigits(16)
    |> new()
  end

  @spec new(value_range()) :: t()
  def new(value) when is_integer(value) and value in 0x000..0xFFF do
    %__MODULE__{
      value: value
    }
  end
end
