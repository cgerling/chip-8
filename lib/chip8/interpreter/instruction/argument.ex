defmodule Chip8.Interpreter.Instruction.Argument do
  @moduledoc """
  Helper module to handle and parse instruction argument values
  """

  @type nibble() :: 0x0..0xF

  defguard is_nibble(value) when is_integer(value) and value in 0x0..0xF
end
