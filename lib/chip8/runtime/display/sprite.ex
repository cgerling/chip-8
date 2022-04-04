defmodule Chip8.Runtime.Display.Sprite do
  @moduledoc false

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
