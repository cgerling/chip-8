defmodule Chip8.Interpreter.Display.Coordinates do
  @moduledoc false

  @enforce_keys [:x, :y]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer()
        }

  @spec new(integer(), integer()) :: t()
  def new(x, y) when is_integer(x) and is_integer(y) do
    %__MODULE__{
      x: x,
      y: y
    }
  end

  @spec add(t(), t()) :: t()
  def add(%__MODULE__{} = a, %__MODULE__{} = b) do
    x = a.x + b.x
    y = a.y + b.y

    new(x, y)
  end

  @spec from_ordinal(non_neg_integer(), pos_integer()) :: t()
  def from_ordinal(ordinal, max_y) when is_integer(ordinal) and is_integer(max_y) do
    x = rem(ordinal, max_y)
    y = Integer.floor_div(ordinal, max_y)

    new(x, y)
  end
end
