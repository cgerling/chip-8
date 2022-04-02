defmodule Chip8.Instruction.CALL do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Address
  alias Chip8.Runtime
  alias Chip8.Stack

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, {%Address{} = address}) do
    pushed_stack = Stack.push(runtime.stack, runtime.pc)

    %{runtime | pc: address.value, stack: pushed_stack}
  end
end
