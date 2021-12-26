defmodule Chip8.Memory do
  @moduledoc false

  @enforce_keys [:data, :size]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          data: list(byte()),
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
end
