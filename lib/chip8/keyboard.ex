defmodule Chip8.Keyboard do
  @moduledoc false

  @enforce_keys [:keys]
  defstruct @enforce_keys

  @type key :: 0x0..0xF
  @type key_states :: :none

  @type t :: %__MODULE__{
          keys: %{key() => key_states()}
        }

  @spec new() :: t()
  def new do
    keys = Map.new(0x0..0xF, &{&1, :none})

    %__MODULE__{keys: keys}
  end
end
