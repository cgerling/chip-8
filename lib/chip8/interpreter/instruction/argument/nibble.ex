defmodule Chip8.Interpreter.Instruction.Argument.Nibble do
  @moduledoc """
  A 4-bit integer literal value.
  """

  import Chip8.Interpreter.Instruction.Argument

  alias Chip8.Interpreter.Instruction.Argument

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          value: 0x0..0xF
        }

  @spec new(Argument.nibble()) :: t()
  def new(nibble) when is_nibble(nibble) do
    %__MODULE__{
      value: nibble
    }
  end
end
