defmodule Chip8.Instruction.CALL do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Runtime
  alias Chip8.Stack

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{address: address}) do
    pushed_stack = Stack.push(runtime.stack, runtime.pc)

    %{runtime | pc: address, stack: pushed_stack}
  end
end
