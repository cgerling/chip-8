defmodule Chip8.VRegisters do
  @moduledoc false

  @enforce_keys [:data]
  defstruct @enforce_keys

  @type register :: 0x0..0xF

  @type t :: %__MODULE__{
          data: %{register() => byte()}
        }

  @spec new() :: t()
  def new do
    data = Map.new(0x0..0xF, &{&1, 0})

    %__MODULE__{
      data: data
    }
  end

  @spec get(t(), register()) :: non_neg_integer()
  def get(%__MODULE__{data: data}, register) when is_integer(register) and register in 0x0..0xF do
    data[register]
  end
end
