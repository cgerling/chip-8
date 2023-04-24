defmodule Chip8 do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Keyboard

  @doc """
  Changes the cycle rate of an interpreter.

  ```elixir
    iex> Chip8.change_cycle_rate(interpreter, 6)
    %Chip8.Interpreter{}
  ```
  """
  @spec change_cycle_rate(Interpreter.t(), pos_integer()) :: Interpreter.t()
  defdelegate change_cycle_rate(interpreter, cycle_rate), to: Interpreter

  @doc """
  Executes a single instruction cycle.

  A cycle is composed of 3 steps: fetch the instruction from memory, decode the
  instruction bytes and executes it by changing the interpreter's state.
  See the cycle section at `Chip8.Interpreter` for more information.

  ```elixir
    iex> Chip8.cycle(interpreter)
    %Chip8.Interpreter{}
  ```
  """
  @spec cycle(Interpreter.t()) :: {:ok, Interpreter.t()} | {:error, atom()}
  defdelegate cycle(interpreter), to: Interpreter

  @doc """
  Shortcut to `Chip8.initialize/2`.

  ```elixir
    iex> program = File.read!(path)
    iex> Chip8.initialize(program)
    %Chip8.Interpreter{}
  ```
  """
  @spec initialize(bitstring()) :: Interpreter.t()
  defdelegate initialize(program), to: Interpreter

  @doc """
  Creates an interpreter instance with the given program loaded into its memory.

  ## Options

  * `cycle_rate` - amount of instructions that are going to be executed each
    cycle. Defaults to 10 when not specified.

  ```elixir
    iex> program = File.read!(path)
    iex> Chip8.initialize(program, cycle_rate: 10)
    %Chip8.Interpreter{}
  ```
  """
  @spec initialize(bitstring(), Keyword.t()) :: Interpreter.t()
  defdelegate initialize(program, opts), to: Interpreter

  @doc """
  Returns a pixelmap with the current content of the display.

  This pixelmap is a list matrix with each pixel "state" of the whole display.
  See `Chip8.Interpreter.Display` for more information.

  ```elixir
    iex> Chip8.pixelmap(interpreter)
    [[0, 0, 1, ...], [0, 0, ...], [1, ...], [...], ...]
  ```
  """
  @spec pixelmap(Interpreter.t()) :: Display.pixelmap()
  defdelegate pixelmap(interpreter), to: Interpreter

  @doc """
  Computes a key press event on the hexadecimal keyboard.

  See `Chip8.Interpreter.Keyboard` for more information.

  ```elixir
    iex> Chip8.press_key(interpreter, 0xA)
    %Chip8.Interpreter{}
  ```
  """
  @spec press_key(Interpreter.t(), Keyboard.key()) :: Interpreter.t()
  defdelegate press_key(interpreter, key), to: Interpreter

  @doc """
  Computes a key release event on the hexadecimal keyboard.

  See `Chip8.Interpreter.Keyboard` for more information.

  ```elixir
    iex> Chip8.release_key(interpreter, 0xA)
    %Chip8.Interpreter{}
  ```
  """
  @spec release_key(Interpreter.t(), Keyboard.key()) :: Interpreter.t()
  defdelegate release_key(interpreter, key), to: Interpreter

  @doc """
  Performs the tick logic for all timers.

  This function does not set timers to decrement at the required rate, only
  performing the tick itself.
  See `Chip8.Interpreter.Timer` for more information on timers.

  ```elixir
    iex> Chip8.tick_timers(interpreter)
    %Chip8.Interpreter{}
  ```
  """
  @spec tick_timers(Interpreter.t()) :: Interpreter.t()
  defdelegate tick_timers(interpreter), to: Interpreter

  @doc """
  Returns a `boolean()` representing the current state of the given timer.
  This is usefull to run custom logic based on a timer state, for example
  emitting sound when the sound timer is active.

  See `Chip8.Interpreter.Timer` for more information on timers.

  ```elixir
    iex> Chip8.is_timer_active?(interpreter, :dt)
    false

    iex> Chip8.is_timer_active?(interpreter, :st)
    true
  ```
  """
  @spec is_timer_active?(Interpreter.t(), Interpreter.timers()) :: boolean()
  defdelegate is_timer_active?(interpreter, timer), to: Interpreter

  @doc """
  Returns a list containing all the pixels from the second interpreter that has
  a different state from their equivalent pixels on the first interpreter. The
  list is composed of tuples, each tuple has its first element being the
  pixel's coordinates (`t:Display.Coordinates.t/0`) and the second element is
  the state they have in the second interpreter.

  This is useful when rendering only the pixels that changed during a cycle.

  ```elixir
    iex> interpreter = Chip8.initialize()
    iex> Chip8.display_changes(interpreter, interpreter)
    []

    iex> cycled_interpreter = Chip8.cycle(interpreter)
    iex> Chip8.display_changes(interpreter, cycled_interpreter)
    [...]
  ```
  """
  @spec display_changes(Interpreter.t(), Interpreter.t()) :: Display.diff()
  defdelegate display_changes(interpreter_a, interpreter_b), to: Interpreter
end
