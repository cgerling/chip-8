defmodule Chip8.Runtime.Instruction.RET do
  @moduledoc false

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Stack

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {}) do
    case Stack.pop(runtime.stack) do
      {nil, _stack} -> runtime
      {address, stack} -> %{runtime | pc: address, stack: stack}
    end
  end
end
