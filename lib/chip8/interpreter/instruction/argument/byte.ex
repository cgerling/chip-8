defmodule Chip8.Interpreter.Instruction.Argument.Byte do
  @moduledoc """
  An 8-bit integer literal value.
  """

  import Chip8.Interpreter.Instruction.Argument

  alias Chip8.Hex
  alias Chip8.Interpreter.Instruction.Argument

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type value() :: 0x00..0xFF

  @type t() :: %__MODULE__{
          value: value()
        }

  @spec new(Argument.nibble(), Argument.nibble()) :: t()
  def new(byte1, byte2) when is_nibble(byte1) and is_nibble(byte2) do
    [byte1, byte2]
    |> Hex.from_digits()
    |> new()
  end

  @spec new(value()) :: t()
  def new(value) when is_integer(value) and value in 0x00..0xFF do
    %__MODULE__{
      value: value
    }
  end
end
