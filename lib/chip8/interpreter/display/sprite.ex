defmodule Chip8.Interpreter.Display.Sprite do
  @moduledoc """
  Group of bytes representing the binary structure of an image.

  Sprites may be up to `15 bytes`, making it possible to have a maximum
  dimension of `8x15` pixels (8 pixels wide and 15 pixels high). 
  When a sprite _heigth_ is an odd number, the sprite should be padded in
  order to become an even number to not interfere with the instructions
  location pattern, see `Chip8.Interpreter.Instruction` for more information.

  Sprites are also used to represent the hexadecimal characters of the
  built-in font, in this case, the sprites will be 5 pixels wide, see
  `Chip8.Interpreter.Font` for more information.
  """

  @enforce_keys [:data]
  defstruct @enforce_keys

  @type bit :: 0 | 1
  @type bitmap :: list(list(bit()))

  @type t :: %__MODULE__{
          data: list(byte())
        }

  @width 8

  @spec new(list()) :: t()
  def new(data) when is_list(data) do
    %__MODULE__{
      data: data
    }
  end

  @spec to_bitmap(t()) :: bitmap()
  def to_bitmap(%__MODULE__{data: data}) do
    Enum.map(data, fn byte ->
      bits = Integer.digits(byte, 2)

      padding_amount = @width - Enum.count(bits)
      padding = List.duplicate(0, padding_amount)

      List.flatten([padding | bits])
    end)
  end
end
