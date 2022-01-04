defmodule Chip8.Runtime do
  @moduledoc false

  alias Chip8.Display
  alias Chip8.Font
  alias Chip8.Instruction
  alias Chip8.Keyboard
  alias Chip8.Memory
  alias Chip8.Stack
  alias Chip8.UInt
  alias Chip8.VRegisters

  @enforce_keys [:display, :dt, :i, :keyboard, :memory, :pc, :st, :stack, :v]
  defstruct @enforce_keys

  @type timer :: non_neg_integer()

  @type t :: %__MODULE__{
          display: Display.t(),
          dt: timer(),
          i: non_neg_integer(),
          keyboard: Keyboard.t(),
          memory: Memory.t(),
          pc: non_neg_integer(),
          st: timer(),
          stack: Stack.t(),
          v: VRegisters.t()
        }

  @display_height 32
  @display_width 64
  @memory_size 4096

  @initial_pc 0x200
  @instruction_size Instruction.byte_size()
  @font_address 0x050
  @character_size Font.character_byte_size()

  @spec new() :: t()
  def new do
    display = Display.new(@display_height, @display_width)
    keyboard = Keyboard.new()
    memory = Memory.new(@memory_size)
    pc = @initial_pc
    stack = Stack.new()
    v = VRegisters.new()

    %__MODULE__{
      display: display,
      dt: 0,
      i: 0,
      keyboard: keyboard,
      memory: memory,
      pc: pc,
      st: 0,
      stack: stack,
      v: v
    }
  end

  @spec to_next_instruction(t()) :: t()
  def to_next_instruction(%__MODULE__{} = runtime) do
    next_instruction_address = UInt.to_uint12(runtime.pc + @instruction_size)
    %{runtime | pc: next_instruction_address}
  end

  @spec to_previous_instruction(t()) :: t()
  def to_previous_instruction(%__MODULE__{} = runtime) do
    previous_instruction_address = UInt.to_uint12(runtime.pc - @instruction_size)
    %{runtime | pc: previous_instruction_address}
  end

  @spec get_font_character_address(0x0..0xF) :: non_neg_integer()
  def get_font_character_address(character) when is_integer(character) and character in 0x0..0xF,
    do: @font_address + @character_size * character

  @spec load_font(t(), Memory.data()) :: t()
  def load_font(%__MODULE__{} = runtime, font_data) when is_list(font_data) do
    memory_with_font = Memory.write(runtime.memory, @font_address, font_data)

    %{runtime | memory: memory_with_font}
  end
end
