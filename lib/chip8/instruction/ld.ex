defmodule Chip8.Instruction.LD do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: x, operation: :bcd}) do
    register_x = VRegisters.get(runtime.v, x)
    decimal_digits = Integer.digits(register_x, 10)

    memory = Memory.write(runtime.memory, runtime.i, decimal_digits)
    %{runtime | memory: memory}
  end
end
