defmodule Chip8.Runtime do
  @moduledoc false

  alias Chip8.Runtime.Display
  alias Chip8.Runtime.Font
  alias Chip8.Runtime.Instruction
  alias Chip8.Runtime.Keyboard
  alias Chip8.Runtime.Memory
  alias Chip8.Runtime.Stack
  alias Chip8.Runtime.Timer
  alias Chip8.Runtime.VRegisters
  alias Chip8.UInt

  @enforce_keys [:display, :dt, :i, :keyboard, :memory, :pc, :st, :stack, :v]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          display: Display.t(),
          dt: Timer.t(),
          i: non_neg_integer(),
          keyboard: Keyboard.t(),
          memory: Memory.t(),
          pc: non_neg_integer(),
          st: Timer.t(),
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
    dt = Timer.new()
    keyboard = Keyboard.new()
    memory = Memory.new(@memory_size)
    pc = @initial_pc
    st = Timer.new()
    stack = Stack.new()
    v = VRegisters.new()

    %__MODULE__{
      display: display,
      dt: dt,
      i: 0,
      keyboard: keyboard,
      memory: memory,
      pc: pc,
      st: st,
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

  @spec load_program(t(), Memory.data()) :: t()
  def load_program(%__MODULE__{} = runtime, program) when is_list(program) do
    memory = Memory.write(runtime.memory, @initial_pc, program)
    %{runtime | memory: memory}
  end

  @spec cycle(t()) :: {:ok, t()} | {:error, atom()}
  def cycle(%__MODULE__{} = runtime) do
    runtime
    |> tick_timers()
    |> run_instruction()
  end

  defp run_instruction(%__MODULE__{} = runtime) do
    data = Memory.read(runtime.memory, runtime.pc, @instruction_size)

    with {:ok, %Instruction{} = instruction} <- Instruction.decode(data) do
      runtime = to_next_instruction(runtime)
      executed_runtime = Instruction.execute(instruction, runtime)

      {:ok, executed_runtime}
    end
  end

  defp tick_timers(%__MODULE__{} = runtime) do
    dt = Timer.tick(runtime.dt)
    st = Timer.tick(runtime.st)

    %{runtime | dt: dt, st: st}
  end
end
