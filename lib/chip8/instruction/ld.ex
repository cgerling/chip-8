defmodule Chip8.Instruction.LD do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Font
  alias Chip8.Instruction
  alias Chip8.Keyboard
  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.VRegisters

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: :bcd, y: y}) do
    register_y = VRegisters.get(runtime.v, y)
    decimal_digits = Integer.digits(register_y, 10)

    memory = Memory.write(runtime.memory, runtime.i, decimal_digits)
    %{runtime | memory: memory}
  end

  def execute(%Runtime{} = runtime, %{x: :memory, y: y}) do
    registers = Enum.map(0..y, &VRegisters.get(runtime.v, &1))

    memory = Memory.write(runtime.memory, runtime.i, registers)
    %{runtime | memory: memory}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: :memory}) do
    data = Memory.read(runtime.memory, runtime.i, x + 1)

    v_registers =
      data
      |> Enum.with_index()
      |> Enum.reduce(runtime.v, fn {value, index}, v ->
        VRegisters.set(v, index, value)
      end)

    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: :dt}) do
    v_registers = VRegisters.set(runtime.v, x, runtime.dt)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: :dt, y: y}) do
    register_y = VRegisters.get(runtime.v, y)
    %{runtime | dt: register_y}
  end

  def execute(%Runtime{} = runtime, %{x: :st, y: y}) do
    register_y = VRegisters.get(runtime.v, y)
    %{runtime | st: register_y}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: :keyboard}) do
    key_pressed = Keyboard.keys() |> Enum.find(&Keyboard.is_pressed?(runtime.keyboard, &1))

    if is_nil(key_pressed) do
      %{runtime | pc: runtime.pc - Instruction.byte_size()}
    else
      v_registers = VRegisters.set(runtime.v, x, key_pressed)
      %{runtime | v: v_registers}
    end
  end

  def execute(%Runtime{} = runtime, %{x: x, y: y}) do
    register_y = VRegisters.get(runtime.v, y)

    v_registers = VRegisters.set(runtime.v, x, register_y)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, %{x: x, byte: byte}) do
    v_registers = VRegisters.set(runtime.v, x, byte)
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
