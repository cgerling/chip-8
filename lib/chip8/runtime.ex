defmodule Chip8.Runtime do
  @moduledoc false

  alias Chip8.Display

  @enforce_keys [:display, :dt, :i, :memory, :pc, :st, :stack, :v]
  defstruct @enforce_keys

  @type timer :: non_neg_integer()

  @type t :: %__MODULE__{
          display: Display.t(),
          dt: timer(),
          i: byte(),
          memory: list(byte()),
          pc: non_neg_integer(),
          st: timer(),
          stack: list(byte()),
          v: %{(0x0..0xF) => byte()}
        }

  @display_height 32
  @display_width 64

  @spec new() :: t()
  def new do
    display = Display.new(@display_height, @display_width)
    memory = List.duplicate(0, 4096)
    stack = []
    v = Map.new(0x0..0xF, &{&1, 0})

    %__MODULE__{
      display: display,
      dt: 0,
      i: 0,
      memory: memory,
      pc: 0,
      st: 0,
      stack: stack,
      v: v
    }
  end
end
