defmodule Chip8.Interpreter.Instruction.Argument do
  @moduledoc false

  @type nibble() :: 0x0..0xF

  defguard is_nibble(value) when is_integer(value) and value in 0x0..0xF
end
