defmodule Chip8.Instruction.LD do
  @moduledoc false

  @behaviour Chip8.Instruction

  alias Chip8.Font
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

  def execute(%Runtime{} = runtime, %{x: x, operation: :store}) do
    registers = Enum.map(0..x, &VRegisters.get(runtime.v, &1))

    memory = Memory.write(runtime.memory, runtime.i, registers)
    %{runtime | memory: memory}
  end

  def execute(%Runtime{} = runtime, %{x: x, operation: :load}) do
    data = Memory.read(runtime.memory, runtime.i, x + 1)

    v_registers =
      data
      |> Enum.with_index()
      |> Enum.reduce(runtime.v, fn {value, index}, v ->
        VRegisters.set(v, index, value)
      end)

    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    v_registers = VRegisters.set(runtime.v, x, byte)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_y = VRegisters.get(runtime.v, y)

    v_registers = VRegisters.set(runtime.v, x, register_y)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{address: address}) do
    %{runtime | i: address}
  end

  def execute(%Runtime{} = runtime, %{x: x}) do
    register_x = VRegisters.get(runtime.v, x)
    character_address = Font.address(register_x)

    %{runtime | i: character_address}
  end
end
