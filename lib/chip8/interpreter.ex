defmodule Chip8.Interpreter do
  @moduledoc """
  An interpreter for the Chip-8 language.

  The interpreter uses the following components to run a program:

  Display             | A monochrome display used to render graphics. See `Chip8.Interpreter.Display` for more information.
  Memory              | A memory space of `4Kb` used to store programs and data. See `Chip8.Interpreter.Memory` for more information.
  Delay Timer         | A timer used to coordinate events within a program, usually referred to as _dt_. See `Chip8.Interpreter.Timer` for more information.
  Sound Timer         | A timer used to emit a monotone sound while it's active, usually referred to as _st_. See `Chip8.Interpreter.Timer` for more information.
  Stack               | A stack to store and retrieve memory addresses when calling and returning from subroutines.
  Program Counter     | A 16-bit integer that points to the memory address of the current instruction, and is usually referred to as _pc_.
  I                   | A 16-bit register used to point to memory locations, usually to render sprites.
  Variable Registers  | 16 8-bit registers to store and retrieve variable data. See `Chip8.Interpreter.VRegisters` for more information.

  Note that some of the components above are only accessible to programs
  through specific instructions (e.g. display and memory components) and some
  are not accessible at all (i.e. program counter).

  ## Cycle

  At each cycle, the interpreter performs the same sequence of steps until the
  the program reaches its end:

  1. **Fetch** `2 bytes` of memory from the address that _pc_ is pointing at;
  1. **Decode** the fetched bytes into an _opcode_ with its operands;
  1. **Execute** the _opcode_ by updating the interpreter state based on
  the _opcode_ specification.

  All programs are executed through this simple routine, so to
  prevent the interpreter to stop running they create an infinite loop
  (either a direct or indirect one) and keep executing until the user
  quits the application.
  """

  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Font
  alias Chip8.Interpreter.Instruction
  alias Chip8.Interpreter.Keyboard
  alias Chip8.Interpreter.Memory
  alias Chip8.Interpreter.Timer
  alias Chip8.Interpreter.VRegisters
  alias Chip8.Stack
  alias Chip8.UInt

  require Chip8.Interpreter.Font
  require Keyboard

  @enforce_keys [:cycle_rate, :display, :dt, :i, :keyboard, :memory, :pc, :st, :stack, :v]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          cycle_rate: pos_integer(),
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

  @default_cycle_rate 10
  @default_i 0x0

  @spec initialize(bitstring()) :: t()
  @spec initialize(bitstring(), Keyword.t()) :: t()
  def initialize(program, opts \\ []) when is_bitstring(program) do
    font = Font.data()

    opts
    |> new()
    |> load_font(font)
    |> load_program(program)
  end

  @spec new() :: t()
  @spec new(Keyword.t()) :: t()
  def new(opts \\ []) do
    cycle_rate = Keyword.get(opts, :cycle_rate, @default_cycle_rate)
    display = Display.new(@display_height, @display_width)
    dt = Timer.new()
    i = @default_i
    keyboard = Keyboard.new()
    memory = Memory.new(@memory_size)
    pc = @initial_pc
    st = Timer.new()
    stack = Stack.new()
    v = VRegisters.new()

    %__MODULE__{
      cycle_rate: cycle_rate,
      display: display,
      dt: dt,
      i: i,
      keyboard: keyboard,
      memory: memory,
      pc: pc,
      st: st,
      stack: stack,
      v: v
    }
  end

  @spec to_next_instruction(t()) :: t()
  def to_next_instruction(%__MODULE__{} = interpreter) do
    next_instruction_address = UInt.to_uint12(interpreter.pc + @instruction_size)
    %{interpreter | pc: next_instruction_address}
  end

  @spec to_previous_instruction(t()) :: t()
  def to_previous_instruction(%__MODULE__{} = interpreter) do
    previous_instruction_address = UInt.to_uint12(interpreter.pc - @instruction_size)
    %{interpreter | pc: previous_instruction_address}
  end

  @spec get_font_character_address(Font.character()) :: non_neg_integer()
  def get_font_character_address(character) when Font.is_character(character),
    do: @font_address + @character_size * character

  @spec load_font(t(), Memory.data()) :: t()
  def load_font(%__MODULE__{} = interpreter, font_data) when is_list(font_data) do
    memory_with_font = Memory.write(interpreter.memory, @font_address, font_data)

    %{interpreter | memory: memory_with_font}
  end

  @spec load_program(t(), bitstring()) :: t()
  def load_program(%__MODULE__{} = interpreter, program) when is_bitstring(program) do
    program_data = :binary.bin_to_list(program)
    memory = Memory.write(interpreter.memory, @initial_pc, program_data)

    %{interpreter | memory: memory}
  end

  @spec cycle(t()) :: {:ok, t()} | {:error, atom()}
  def cycle(%__MODULE__{} = interpreter) do
    rate = 1..interpreter.cycle_rate

    Enum.reduce_while(rate, {:ok, interpreter}, fn _, {:ok, interpreter} ->
      case run_cycle(interpreter) do
        {:ok, interpreter} -> {:cont, {:ok, interpreter}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp run_cycle(%__MODULE__{} = interpreter) do
    data = Memory.read(interpreter.memory, interpreter.pc, @instruction_size)

    with {:ok, %Instruction{} = instruction} <- Instruction.decode(data) do
      interpreter = to_next_instruction(interpreter)
      executed_interpreter = Instruction.execute(instruction, interpreter)

      {:ok, executed_interpreter}
    end
  end

  @spec tick_timers(t()) :: t()
  def tick_timers(%__MODULE__{} = interpreter) do
    dt = Timer.tick(interpreter.dt)
    st = Timer.tick(interpreter.st)

    %{interpreter | dt: dt, st: st}
  end

  @spec press_key(t(), Keyboard.key()) :: t()
  def press_key(%__MODULE__{} = interpreter, key) when Keyboard.is_key(key) do
    keyboard = Keyboard.press_key(interpreter.keyboard, key)
    %{interpreter | keyboard: keyboard}
  end

  @spec release_key(t(), Keyboard.key()) :: t()
  def release_key(%__MODULE__{} = interpreter, key) when Keyboard.is_key(key) do
    keyboard = Keyboard.release_key(interpreter.keyboard, key)
    %{interpreter | keyboard: keyboard}
  end

  @spec pixelmap(t()) :: Display.pixelmap()
  def pixelmap(%__MODULE__{display: display}) do
    Display.pixelmap(display)
  end

  @spec change_cycle_rate(t(), pos_integer()) :: t()
  def change_cycle_rate(%__MODULE__{} = interpreter, cycle_rate)
      when is_integer(cycle_rate) and cycle_rate > 0 do
    %{interpreter | cycle_rate: cycle_rate}
  end
end
