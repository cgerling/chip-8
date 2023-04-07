defmodule Chip8.Interpreter.Memory do
  @moduledoc """
  Memory space available for programs to store and manipulate data.

  The Chip-8 interpreter has a total of `4Kb` (4096 bytes) of memory space,
  that is accessible from address `0x000` (`0`) to `0xFFF` (`4095`). 

  Originally, the interpreter implementation shared the same memory space
  of programs and occupied the sector between `0x000` (`0`) and `0x1FF` 
  (`511`), for this reason, programs should not use the interpreter space
  so they usually start at location `0x200` (`512`).
  """

  @enforce_keys [:data, :size]
  defstruct @enforce_keys

  @type address :: non_neg_integer()
  @type data() :: [byte()]

  @type t() :: %__MODULE__{
          data: %{address() => byte()},
          size: non_neg_integer()
        }

  @spec new(non_neg_integer()) :: t()
  def new(size) when is_integer(size) do
    data = Map.new(0..(size - 1), &{&1, 0})

    %__MODULE__{
      data: data,
      size: size
    }
  end

  @spec read(t(), address(), non_neg_integer()) :: data()
  def read(%__MODULE__{} = memory, address, amount)
      when is_integer(address) and is_integer(amount) do
    address_range = build_address_range(memory, address, amount)

    Enum.map(address_range, &Map.fetch!(memory.data, &1))
  end

  @spec write(t(), address(), data()) :: t()
  def write(%__MODULE__{} = memory, address, data)
      when is_integer(address) and is_list(data) do
    amount = Enum.count(data)
    address_range = build_address_range(memory, address, amount)

    data =
      address_range
      |> Enum.zip(data)
      |> Enum.reduce(memory.data, fn {address, value}, data ->
        Map.replace(data, address, value)
      end)

    %{memory | data: data}
  end

  defp build_address_range(%__MODULE__{}, _address, amount) when amount <= 0, do: []

  defp build_address_range(%__MODULE__{}, address, _amount) when address < 0, do: []

  defp build_address_range(%__MODULE__{size: size}, address, _amount) when address >= size, do: []

  defp build_address_range(%__MODULE__{size: size}, address, amount) do
    range_start = address
    range_end = min(address + amount, size) - 1

    range_start..range_end//1
  end
end
