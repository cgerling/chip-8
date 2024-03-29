defmodule Chip8.Interpreter.VRegisters do
  @moduledoc """
  General purpose _variable_ registers.

  Registers are numbered from `0` to `F` and have a size of 8 bits.
  They are usually refered as V registers through the notation `Vx`, where
  `x` is a hexadecimal number.

  Some instructions use `VF` as a flag register, setting it to either `0` or
  `1` depending of the operation, for this reason most programs tend to avoid
  relying on this register to store data.
  """

  @behaviour Access

  @enforce_keys [:data]
  defstruct @enforce_keys

  @type register() :: 0x0..0xF

  @type t() :: %__MODULE__{
          data: %{register() => byte()}
        }

  defguard is_register(value) when is_integer(value) and value in 0x0..0xF

  @spec new() :: t()
  def new do
    data = Map.new(0x0..0xF, &{&1, 0})

    %__MODULE__{
      data: data
    }
  end

  @spec get(t(), register()) :: non_neg_integer()
  def get(%__MODULE__{data: data}, register) when is_register(register) do
    data[register]
  end

  @spec set(t(), register(), non_neg_integer()) :: t()
  def set(%__MODULE__{} = v_registers, register, value) when is_register(register) do
    data = %{v_registers.data | register => value}

    %{v_registers | data: data}
  end

  @impl Access
  def fetch(%__MODULE__{} = v_registers, register) when is_register(register) do
    value = get(v_registers, register)
    {:ok, value}
  end

  def fetch(%__MODULE__{}, _register) do
    :error
  end

  @impl Access
  def get_and_update(%__MODULE__{} = v_registers, register, fun)
      when is_register(register) and is_function(fun, 1) do
    current_value = get(v_registers, register)

    case fun.(current_value) do
      {get_value, new_value} ->
        {get_value, set(v_registers, register, new_value)}

      :pop ->
        pop(v_registers, register)

      other ->
        raise "the given function must return a two-element tuple or :pop, got: #{inspect(other)}"
    end
  end

  def get_and_update(%__MODULE__{} = v_registers, _register, _fun) do
    {0x0, v_registers}
  end

  @impl Access
  def pop(%__MODULE__{} = v_registers, register) when is_register(register) do
    current_value = get(v_registers, register)

    {current_value, set(v_registers, register, 0x0)}
  end

  def pop(%__MODULE__{} = v_registers, _) do
    {0x0, v_registers}
  end
end
