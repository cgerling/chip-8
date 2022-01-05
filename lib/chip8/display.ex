defmodule Chip8.Display do
  @moduledoc false

  alias Chip8.Sprite

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

  @spec get_coordinates(t(), non_neg_integer(), non_neg_integer()) :: coordinates()
  def get_coordinates(%__MODULE__{} = display, x, y) when is_integer(x) and is_integer(y) do
    coordinate_x = rem(x, display.height)
    coordinate_y = rem(y, display.width)

    {coordinate_x, coordinate_y}
  end

  @spec draw(t(), coordinates(), Sprite.t()) :: t()
  def draw(%__MODULE__{} = display, {x, y}, %Sprite{} = sprite) do
    visible_sprite_width = max(display.width - x, 0)

    pixels =
      sprite
      |> Sprite.to_bitmap()
      |> Enum.with_index()
      |> Enum.reduce(display.pixels, fn {byte, y_index}, pixels ->
        byte
        |> Enum.slice(0, visible_sprite_width)
        |> Enum.with_index()
        |> Enum.reduce(pixels, fn {bit, x_index}, pixels ->
          position = display.width * (y + y_index) + (x + x_index)

          List.update_at(pixels, position, &Bitwise.bxor(&1, bit))
        end)
      end)

    %{display | pixels: pixels}
  end

  @spec has_collision?(t(), t()) :: boolean()
  def has_collision?(%__MODULE__{pixels: before_pixels}, %__MODULE__{pixels: after_pixels}) do
    before_pixels
    |> Enum.zip(after_pixels)
    |> Enum.any?(fn {before_pixel, after_pixel} -> before_pixel > after_pixel end)
  end
end
