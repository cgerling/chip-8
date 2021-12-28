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

  defguardp is_register(register) when is_integer(register) and register in 0x0..0xF

  @spec get(t(), register()) :: non_neg_integer()
  def get(%__MODULE__{data: data}, register) when is_register(register) do
    data[register]
  end

  @spec set(t(), register(), non_neg_integer()) :: t()
  def set(%__MODULE__{} = v_registers, register, value) when is_register(register) do
    data = %{v_registers.data | register => value}

    %{v_registers | data: data}
  end
end
