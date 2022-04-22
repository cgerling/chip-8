defmodule Chip8.Runtime.Timer do
  @moduledoc false

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          value: non_neg_integer()
        }

  @spec new() :: t()
  def new do
    new(0)
  end

  @spec new(integer()) :: t()
  def new(value) when is_integer(value) do
    %__MODULE__{
      value: value
    }
  end

  @spec tick(t()) :: t()
  def tick(%__MODULE__{} = timer) do
    value = max(timer.value - 1, 0)

    %{timer | value: value}
  end
end
