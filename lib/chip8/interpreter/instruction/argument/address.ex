defmodule Chip8.Interpreter.Instruction.Argument.Address do
  @moduledoc """
  A 12-bit integer value representing a memory address location.
  """

  import Chip8.Interpreter.Instruction.Argument

  alias Chip8.Hex
  alias Chip8.Interpreter.Instruction.Argument

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type value() :: 0x000..0xFFF

  @type t() :: %__MODULE__{
          value: value()
        }

  @spec new(Argument.nibble(), Argument.nibble(), Argument.nibble()) :: t()
  def new(address1, address2, address3)
      when is_nibble(address1) and is_nibble(address2) and is_nibble(address3) do
    [address1, address2, address3]
    |> Hex.from_digits()
    |> new()
  end

  @spec new(value()) :: t()
  def new(value) when is_integer(value) and value in 0x000..0xFFF do
    %__MODULE__{
      value: value
    }
  end
end
