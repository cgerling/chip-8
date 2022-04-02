defmodule Chip8.Instruction.LD do
  @moduledoc false

  use Chip8.Instruction

  alias Chip8.Instruction.Argument.Address
  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Keyboard
  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.UInt
  alias Chip8.VRegisters

  @i Register.i()

  @impl Chip8.Instruction
  def execute(%Runtime{} = runtime, %{x: :bcd, y: y}) do
    decimal_digits = Integer.digits(runtime.v[y], 10)

    memory = Memory.write(runtime.memory, runtime.i, decimal_digits)
    %{runtime | memory: memory}
  end

  def execute(%Runtime{} = runtime, %{x: :memory, y: y}) do
    registers = Enum.map(0..y, &runtime.v[&1])

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
    %{runtime | dt: runtime.v[y]}
  end

  def execute(%Runtime{} = runtime, %{x: :st, y: y}) do
    %{runtime | st: runtime.v[y]}
  end

  def execute(%Runtime{} = runtime, %{x: :font, y: y}) do
    character_address = Runtime.get_font_character_address(runtime.v[y])
    %{runtime | i: character_address}
  end

  def execute(%Runtime{} = runtime, %{x: x, y: :keyboard}) do
    key_pressed = Keyboard.keys() |> Enum.find(&Keyboard.is_pressed?(runtime.keyboard, &1))

    if is_nil(key_pressed) do
      Runtime.to_previous_instruction(runtime)
    else
      v_registers = VRegisters.set(runtime.v, x, key_pressed)
      %{runtime | v: v_registers}
    end
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    v_registers = VRegisters.set(runtime.v, x.value, runtime.v[y.value])
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    byte = UInt.to_uint8(byte.value)
    v_registers = VRegisters.set(runtime.v, x.value, byte)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {@i, %Address{} = address}) do
    address = UInt.to_uint16(address.value)
    %{runtime | i: address}
  end
end
