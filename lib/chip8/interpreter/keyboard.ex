defmodule Chip8.Interpreter.Keyboard do
  @moduledoc """
  A keyboard input device.

  Users can interact with programs through a hexadecimal keypad that was
  present in the original Chip-8 computer.

  Keys are represented by hexadecimal integers. When a user presses the F key,
  the key needs to be registered as 15 instead. For this purpose, you can
  either use the hexadecimal notation (e.g. `0xF` returns `15`) for a
  hard-coded mapping or `String.to_integer/2`
  (e.g. `String.to_integer("F", 16)` returns `15`) for a more dynamic approach.
  """

  @enforce_keys [:keys]
  defstruct @enforce_keys

  @type key() :: 0x0..0xF
  @type key_state() :: :none | :pressed

  @type t() :: %__MODULE__{
          keys: %{key() => key_state()}
        }

  defguard is_key(key) when is_integer(key) and key in 0x0..0xF

  @spec new() :: t()
  def new do
    keys = Map.new(0x0..0xF, &{&1, :none})

    %__MODULE__{keys: keys}
  end

  @spec keys() :: [key(), ...]
  def keys, do: Enum.to_list(0x0..0xF)

  @spec is_pressed?(t(), key()) :: boolean()
  def is_pressed?(%__MODULE__{} = keyboard, key) when is_key(key) do
    keyboard.keys[key] == :pressed
  end

  @spec press_key(t(), key()) :: t()
  def press_key(%__MODULE__{keys: keys}, key) when is_key(key) do
    pressed_keys = %{keys | key => :pressed}
    %__MODULE__{keys: pressed_keys}
  end

  @spec release_key(t(), key()) :: t()
  def release_key(%__MODULE__{keys: keys}, key) when is_key(key) do
    released_keys = %{keys | key => :none}
    %__MODULE__{keys: released_keys}
  end
end
