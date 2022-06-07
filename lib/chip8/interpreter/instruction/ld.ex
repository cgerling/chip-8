defmodule Chip8.Interpreter.Instruction.LD do
  @moduledoc """
  Loads a value into memory, registers, or timers.

  Most of the addressing variations simply loads the value of the second
  operand into the first operand but some posses a special behavior and allow
  to interact with components that are not accessible through registers or
  that perform calculations before saving the data, see "Pseudo-registers"
  section at `Chip8.Interpreter.Instruction.Argument.Register` for more information.

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

  use Chip8.Interpreter.Instruction

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Keyboard
  alias Chip8.Interpreter.Memory
  alias Chip8.Interpreter.Timer
  alias Chip8.Interpreter.VRegisters
  alias Chip8.UInt

  @bcd Register.bcd()
  @dt Register.dt()
  @font Register.font()
  @i Register.i()
  @keyboard Register.keyboard()
  @memory Register.memory()
  @st Register.st()

  @impl Chip8.Interpreter.Instruction
  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Byte{} = byte}) do
    byte = UInt.to_uint8(byte.value)
    v_registers = VRegisters.set(interpreter.v, x.value, byte)
    %{interpreter | v: v_registers}
  end

  def execute(%Interpreter{} = interpreter, {@i, %Address{} = address}) do
    address = UInt.to_uint16(address.value)
    %{interpreter | i: address}
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, @dt}) do
    v_registers = VRegisters.set(interpreter.v, x.value, interpreter.dt.value)
    %{interpreter | v: v_registers}
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, @keyboard}) do
    key_pressed = Keyboard.keys() |> Enum.find(&Keyboard.is_pressed?(interpreter.keyboard, &1))

    if is_nil(key_pressed) do
      Interpreter.to_previous_instruction(interpreter)
    else
      v_registers = VRegisters.set(interpreter.v, x.value, key_pressed)
      %{interpreter | v: v_registers}
    end
  end

  def execute(%Interpreter{} = interpreter, {@dt, %Register{} = x}) do
    dt = Timer.new(interpreter.v[x.value])
    %{interpreter | dt: dt}
  end

  def execute(%Interpreter{} = interpreter, {@st, %Register{} = x}) do
    st = Timer.new(interpreter.v[x.value])
    %{interpreter | st: st}
  end

  def execute(%Interpreter{} = interpreter, {@font, %Register{} = x}) do
    character_address = Interpreter.get_font_character_address(interpreter.v[x.value])
    %{interpreter | i: character_address}
  end

  def execute(%Interpreter{} = interpreter, {@bcd, %Register{} = x}) do
    decimal_digits = Integer.digits(interpreter.v[x.value], 10)

    memory = Memory.write(interpreter.memory, interpreter.i, decimal_digits)
    %{interpreter | memory: memory}
  end

  def execute(%Interpreter{} = interpreter, {@memory, %Register{} = x}) do
    registers = Enum.map(0..x.value, &interpreter.v[&1])

    memory = Memory.write(interpreter.memory, interpreter.i, registers)
    %{interpreter | memory: memory}
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, @memory}) do
    data = Memory.read(interpreter.memory, interpreter.i, x.value + 1)

    v_registers =
      data
      |> Enum.with_index()
      |> Enum.reduce(interpreter.v, fn {value, index}, v ->
        VRegisters.set(v, index, value)
      end)

    %{interpreter | v: v_registers}
  end

  def execute(%Interpreter{} = interpreter, {%Register{} = x, %Register{} = y}) do
    v_registers = VRegisters.set(interpreter.v, x.value, interpreter.v[y.value])
    %{interpreter | v: v_registers}
  end
end
