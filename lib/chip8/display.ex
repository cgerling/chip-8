defmodule Chip8.Display do
  @moduledoc false

  @enforce_keys [:height, :pixels, :width]
  defstruct @enforce_keys

  @type dimension :: non_neg_integer()
  @type pixel :: 0 | 1
  @type coordinates :: {x :: non_neg_integer(), y :: non_neg_integer()}

  @type t :: %__MODULE__{
          height: dimension(),
          pixels: list(pixel),
          width: dimension()
        }

  @spec new(dimension(), dimension()) :: t()
  def new(height, width) when is_integer(height) and is_integer(width) do
    pixels = List.duplicate(0, height * width)

    %__MODULE__{
      height: height,
      pixels: pixels,
      width: width
    }
  end

  @spec clear(t()) :: t()
  def clear(%__MODULE__{height: height, width: width}) do
    new(height, width)
  end

  @spec get_coordinates(t(), integer(), integer()) :: coordinates()
  def get_coordinates(%__MODULE__{} = display, x, y) when is_integer(x) and is_integer(y) do
    coordinate_x = rem(abs(x), display.height)
    coordinate_y = rem(abs(y), display.width)

    {coordinate_x, coordinate_y}
  end
end
