defmodule Chip8.Interpreter.Display.Coordinates do
  @moduledoc """
  Internal module used by `Chip8.Interpreter.Display` to make easier to
  manipulate the tuples representing the pixel coordinates.

  The Coordinates value is a tuple containing two integer values. The first is
  the value of the x-axis (horizontal) and the second is the value of the
  y-axis (vertical).
  """

  @enforce_keys [:x, :y]
  defstruct @enforce_keys

  @type t() :: {x :: integer(), y :: integer()}

  defguard is_coordinates(coordinates)
           when is_tuple(coordinates) and is_integer(elem(coordinates, 0)) and
                  is_integer(elem(coordinates, 1))

  @spec new(integer(), integer()) :: t()
  def new(x, y) when is_integer(x) and is_integer(y) do
    {x, y}
  end

  @spec add(t(), t()) :: t()
  def add({a_x, a_y}, {b_x, b_y}) do
    x = a_x + b_x
    y = a_y + b_y

    new(x, y)
  end

  @spec from_ordinal(non_neg_integer(), pos_integer()) :: t()
  def from_ordinal(ordinal, max_y) when is_integer(ordinal) and is_integer(max_y) do
    x = rem(ordinal, max_y)
    y = Integer.floor_div(ordinal, max_y)

    new(x, y)
  end
end
