defmodule Chip8.Runtime.Keyboard do
  @moduledoc false

  @enforce_keys [:keys]
  defstruct @enforce_keys

  @type key :: 0x0..0xF
  @type key_states :: :none | :pressed

  @type t :: %__MODULE__{
          keys: %{key() => key_states()}
        }

  @spec new() :: t()
  def new do
    keys = Map.new(0x0..0xF, &{&1, :none})

    %__MODULE__{keys: keys}
  end

  @spec keys() :: list(key())
  def keys, do: Enum.to_list(0x0..0xF)

  @spec is_pressed?(t(), key()) :: boolean()
  def is_pressed?(%__MODULE__{} = keyboard, key) when is_integer(key) and key in 0x0..0xF do
    keyboard.keys[key] == :pressed
  end
end
