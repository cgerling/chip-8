defmodule Chip8.Stack do
  @moduledoc """
  A simple **Last In First Out** queue.
  """

  @enforce_keys [:data, :size]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          data: list(byte()),
          size: non_neg_integer()
        }

  @spec new() :: t()
  def new do
    %__MODULE__{
      data: [],
      size: 0
    }
  end

  @spec pop(t()) :: {byte() | nil, t()}
  def pop(%__MODULE__{data: []} = stack), do: {nil, stack}

  def pop(%__MODULE__{data: [address | data]} = stack) do
    popped_stack = %{stack | data: data, size: stack.size - 1}

    {address, popped_stack}
  end

  @spec push(t(), integer()) :: t()
  def push(%__MODULE__{data: data} = stack, value) when is_integer(value) do
    %{stack | data: [value | data], size: stack.size + 1}
  end
end
