defmodule Chip8.Stack do
  @moduledoc false

  @enforce_keys [:data, :size]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
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
end
