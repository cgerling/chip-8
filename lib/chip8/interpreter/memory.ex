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

  @type data() :: list(byte())

  @type t() :: %__MODULE__{
          data: data,
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

  @spec read(t(), non_neg_integer(), non_neg_integer()) :: data()
  def read(%__MODULE__{size: size}, address, _amount) when address >= size, do: []

  def read(%__MODULE__{data: data}, address, amount)
      when is_integer(address) and is_integer(amount) and address >= 0 and amount >= 0 do
    Enum.slice(data, address, amount)
  end

  @spec write(t(), non_neg_integer(), data()) :: t()
  def write(%__MODULE__{} = memory, _address, []), do: memory

  def write(%__MODULE__{} = memory, address, _data) when address >= memory.size, do: memory

  def write(%__MODULE__{} = memory, address, data)
      when is_integer(address) and is_list(data) and is_list(data) do
    writtable_data_size = max(memory.size - address, 0)

    data =
      data
      |> Enum.slice(0, writtable_data_size)
      |> Enum.with_index()
      |> Enum.reduce(memory.data, fn {byte, index}, data ->
        List.replace_at(data, address + index, byte)
      end)

    %{memory | data: data}
  end
end
