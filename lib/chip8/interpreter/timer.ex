defmodule Chip8.Interpreter.Timer do
  @moduledoc """
  A timer is an 8-bit integer that decrements at a constant rate.

  Timers can have two different states, **active** and **inactive**. A timer is
  **active** whenever its value is above 0, while in this state, the value
  decrements whenever a ticks occurs until it reaches 0, when it becomes
  **inactive** and stops decrementing. On each tick, the value decrements on
  steps of 1, and they should run at a rate of `60Hz`. Such rate needs to
  configured externally, it is common that emulators tie up this with the
  display's refresh rate.
  """

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
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

  @spec active?(t()) :: boolean()
  def active?(%__MODULE__{} = timer) do
    timer.value > 0
  end
end
