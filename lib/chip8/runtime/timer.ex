defmodule Chip8.Runtime.Timer do
  @moduledoc """
  A timer is an 8-bit integer that decrements at a specific rate.

  While a program is running, a timer can present two different states, 
  **active** and **inactive**.
  A timer is considered **active** whenever its value is above `0`, while it is
  in this state, the value is decremented on steps of `1` at a rate of `60Hz`,
  once the timer reaches `0` it is considered **inactive** and stops
  decrementing itself.
  """

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
