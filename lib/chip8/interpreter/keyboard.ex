defmodule Chip8.Interpreter.Keyboard do
  @moduledoc """
  A keyboard input device.

  Users can interact with programs through a hexadecimal keypad that was
  present in the original Chip-8 computer.
  """

  @enforce_keys [:keys]
  defstruct @enforce_keys

  @type key :: 0x0..0xF
  @type key_state :: :none | :pressed

  @type t :: %__MODULE__{
          keys: %{key() => key_state()}
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

  @spec press_key(t(), key()) :: t()
  def press_key(%__MODULE__{keys: keys}, key) when is_integer(key) and key in 0x0..0xF do
    pressed_keys = %{keys | key => :pressed}
    %__MODULE__{keys: pressed_keys}
  end
end
