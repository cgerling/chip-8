defmodule Chip8.Interpreter.Display do
  @moduledoc """
  A monochrome display device.

  The monochrome display has a resolution of `64x32` pixels (64 pixels wide and
  32 pixels high), programs can render graphics on it through the use of
  sprites (see `Chip8.Interpreter.Display.Sprite`) and coordinates. The
  _origin_ point of the display is at the top-left corner, with the coordinates
  `(0, 0)`.

  ## Pixelmap

  In most cases, pixelmaps contain the color information of each pixel in the
  screen but, since the COSMAC VIP wasn't able to produce colors and there is no
  way to specify one with the [DRW](`Chip8.Interpreter.Instruction.DRW`)
  instruction, the only information returned is the pixel "state", which can be,
  1 when the pixel is "on" and 0 when is "off".
  """

  alias Chip8.Interpreter.Display.Coordinates
  alias Chip8.Interpreter.Display.Sprite

  @enforce_keys [:height, :pixels, :width]
  defstruct @enforce_keys

  @type dimension() :: non_neg_integer()
  @type pixel() :: 0 | 1
  @type pixelmap() :: [[pixel(), ...], ...]

  @type t() :: %__MODULE__{
          height: dimension(),
          pixels: %{Coordinates.t() => pixel()},
          width: dimension()
        }

  @spec new(dimension(), dimension()) :: t()
  def new(height, width) when is_integer(height) and is_integer(width) do
    last_pixel = height * width - 1
    pixels = Map.new(0..last_pixel, &{Coordinates.from_ordinal(&1, width), 0})

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

  @spec get_coordinates(t(), non_neg_integer(), non_neg_integer()) :: Coordinates.t()
  def get_coordinates(%__MODULE__{} = display, x, y) when is_integer(x) and is_integer(y) do
    x = rem(x, display.width)
    y = rem(y, display.height)

    Coordinates.new(x, y)
  end

  @spec draw(t(), Coordinates.t(), Sprite.t()) :: t()
  def draw(%__MODULE__{} = display, %Coordinates{} = coordinates, %Sprite{} = sprite) do
    visible_width = max(display.width - coordinates.x, 0)
    visible_height = max(display.height - coordinates.y, 0)

    pixels =
      sprite
      |> Sprite.to_bitmap()
      |> Enum.filter(fn {coordinates, _} ->
        coordinates.x < visible_width and coordinates.y < visible_height
      end)
      |> Enum.reduce(display.pixels, fn {bit_coordinates, bit}, pixels ->
        pixel_coordinates = Coordinates.add(coordinates, bit_coordinates)
        Map.update!(pixels, pixel_coordinates, &Bitwise.bxor(&1, bit))
      end)

    %{display | pixels: pixels}
  end

  @spec has_collision?(t(), t()) :: boolean()
  def has_collision?(%__MODULE__{pixels: before_pixels}, %__MODULE__{pixels: after_pixels}) do
    before_pixels
    |> Enum.zip(after_pixels)
    |> Enum.any?(fn {before_pixel, after_pixel} -> before_pixel > after_pixel end)
  end

  @spec create_sprite(Sprite.data()) :: Sprite.t()
  def create_sprite(data) when is_list(data) do
    Sprite.new(data)
  end

  @spec pixelmap(t()) :: pixelmap()
  def pixelmap(%__MODULE__{height: height, pixels: pixels, width: width}) do
    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        coordinates = Coordinates.new(x, y)
        Map.fetch!(pixels, coordinates)
      end
    end
  end
end
