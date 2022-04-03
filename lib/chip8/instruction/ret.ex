defmodule Chip8.Instruction.RET do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.Stack

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {}) do
    case Stack.pop(runtime.stack) do
      {nil, _stack} -> runtime
      {address, stack} -> %{runtime | pc: address, stack: stack}
    end
  end
end
