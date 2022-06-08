defmodule Chip8 do
  @moduledoc false

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Keyboard

  @doc """
  Executes a single instruction cycle.

  A cycle is composed of 3 steps: fetch the instruction from memory, decode the
  instruction bytes and executes it by changing the instance state.
  See the cycle section at `Chip8.Interpreter` for more information.

  ```elixir
    iex> Chip8.cycle(interpreter)
    %Chip8.Interpreter{}
  ```
  """
  @spec cycle(Interpreter.t()) :: {:ok, Interpreter.t()} | {:error, atom()}
  defdelegate cycle(interpreter), to: Interpreter

  @doc """
  Creates an interpreter instance with the given program loaded into its memory.

  ```elixir
    iex> program = File.read!(path)
    iex> Chip8.initialize(program)
    %Chip8.Interpreter{}
  ```
  """
  @spec initialize(bitstring()) :: Interpreter.t()
  defdelegate initialize(program), to: Interpreter

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
end
