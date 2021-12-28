defmodule Chip8.Memory do
  @moduledoc false

  @enforce_keys [:data, :size]
  defstruct @enforce_keys

  @type data :: list(byte())

  @type t :: %__MODULE__{
          data: data,
          size: non_neg_integer()
        }

  @spec new(non_neg_integer()) :: t()
  def new(size) when is_integer(size) do
    data = List.duplicate(0, size)

    %__MODULE__{
      data: data,
      size: size
    }
  end

  @spec read(t(), non_neg_integer(), non_neg_integer()) :: data()
  def read(%__MODULE__{size: size}, address, _amount) when address >= size, do: []

  def read(%__MODULE__{data: data}, address, amount)
      when is_integer(address) and is_integer(amount) and address >= 0 and amount >= 0 do
    Enum.slice(data, address, amount)
  end
end
