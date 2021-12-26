defmodule Chip8.Runtime do
  @moduledoc false

  alias Chip8.Display
  alias Chip8.Memory
  alias Chip8.Stack
  alias Chip8.VRegisters

  @enforce_keys [:display, :dt, :i, :memory, :pc, :st, :stack, :v]
  defstruct @enforce_keys

  @type timer :: non_neg_integer()

  @type t :: %__MODULE__{
          display: Display.t(),
          dt: timer(),
          i: byte(),
          memory: Memory.t(),
          pc: non_neg_integer(),
          st: timer(),
          stack: Stack.t(),
          v: VRegisters.t()
        }

  @display_height 32
  @display_width 64
  @memory_size 4096

  @spec new() :: t()
  def new do
    display = Display.new(@display_height, @display_width)
    memory = Memory.new(@memory_size)
    stack = Stack.new()
    v = VRegisters.new()

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
