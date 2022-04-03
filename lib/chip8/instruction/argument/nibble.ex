defmodule Chip8.Instruction.Argument.Nibble do
  @moduledoc false

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          value: 0x0..0xF
        }

  @spec new(0x0..0xF) :: t()
  def new(nibble) when is_integer(nibble) and nibble in 0x0..0xF do
    %__MODULE__{
      value: nibble
    }
  end
end
