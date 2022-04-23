defmodule Chip8.Runtime.Instruction.LD do
  @moduledoc """
  Loads a value into memory, registers, or timers.

  Most of the addressing variations simply loads the value of the second
  operand into the first operand but some posses a special behavior and allow
  to interact with components that are not accessible through registers or
  that perform calculations before saving the data, see "Pseudo-registers"
  section at `Chip8.Runtime.Instruction.Argument.Register` for more information.

  ## Variants

  Opcode  | Mnemonic              | Description
  :---:   | :---                  | :---
  `6xkk`  | `LD Vx, byte`         | Set `Vx = byte`.
  `8xy0`  | `LD Vx, Vy`           | Set `Vx = Vy`.
  `Annn`  | `LD I, address`       | Set `I = address`.
  `Fx07`  | `LD Vx, DT`           | Set `Vx = DT`.
  `Fx0A`  | `LD Vx, KEY`          | Wait for a keypress and set `Vx = KEY`.
  `Fx15`  | `LD DT, Vx`           | Set `DT = Vx`.
  `Fx18`  | `LD ST, Vx`           | Set `ST = Vx`.
  `Fx29`  | `LD FONT, Vx`         | Set `I = font character addres at Vx`.
  `Fx33`  | `LD BCD, Vx`          | Write a binary-coded decimal representation of `Vx` in memory location `I`, `I + 1`, and `I + 2`.
  `Fx55`  | `LD I, Vx`            | Write the value of registers `V0` through `Vx` in memory, starting at location `I`.
  `Fx65`  | `LD Vx, I`            | Write to registers `V0` through `Vx` from memory, starting at location `I`.
  """

  use Chip8.Runtime.Instruction

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Keyboard
  alias Chip8.Runtime.Memory
  alias Chip8.Runtime.VRegisters
  alias Chip8.UInt

  @bcd Register.bcd()
  @dt Register.dt()
  @font Register.font()
  @i Register.i()
  @keyboard Register.keyboard()
  @memory Register.memory()
  @st Register.st()

  @impl Chip8.Runtime.Instruction
  def execute(%Runtime{} = runtime, {%Register{} = x, %Byte{} = byte}) do
    byte = UInt.to_uint8(byte.value)
    v_registers = VRegisters.set(runtime.v, x.value, byte)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {@i, %Address{} = address}) do
    address = UInt.to_uint16(address.value)
    %{runtime | i: address}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, @dt}) do
    v_registers = VRegisters.set(runtime.v, x.value, runtime.dt)
    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, @keyboard}) do
    key_pressed = Keyboard.keys() |> Enum.find(&Keyboard.is_pressed?(runtime.keyboard, &1))

    if is_nil(key_pressed) do
      Runtime.to_previous_instruction(runtime)
    else
      v_registers = VRegisters.set(runtime.v, x.value, key_pressed)
      %{runtime | v: v_registers}
    end
  end

  def execute(%Runtime{} = runtime, {@dt, %Register{} = x}) do
    %{runtime | dt: runtime.v[x.value]}
  end

  def execute(%Runtime{} = runtime, {@st, %Register{} = x}) do
    %{runtime | st: runtime.v[x.value]}
  end

  def execute(%Runtime{} = runtime, {@font, %Register{} = x}) do
    character_address = Runtime.get_font_character_address(runtime.v[x.value])
    %{runtime | i: character_address}
  end

  def execute(%Runtime{} = runtime, {@bcd, %Register{} = x}) do
    decimal_digits = Integer.digits(runtime.v[x.value], 10)

    memory = Memory.write(runtime.memory, runtime.i, decimal_digits)
    %{runtime | memory: memory}
  end

  def execute(%Runtime{} = runtime, {@memory, %Register{} = x}) do
    registers = Enum.map(0..x.value, &runtime.v[&1])

    memory = Memory.write(runtime.memory, runtime.i, registers)
    %{runtime | memory: memory}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, @memory}) do
    data = Memory.read(runtime.memory, runtime.i, x.value + 1)

    v_registers =
      data
      |> Enum.with_index()
      |> Enum.reduce(runtime.v, fn {value, index}, v ->
        VRegisters.set(v, index, value)
      end)

    %{runtime | v: v_registers}
  end

  def execute(%Runtime{} = runtime, {%Register{} = x, %Register{} = y}) do
    v_registers = VRegisters.set(runtime.v, x.value, runtime.v[y.value])
    %{runtime | v: v_registers}
  end
end
