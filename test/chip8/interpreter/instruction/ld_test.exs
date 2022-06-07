defmodule Chip8.Interpreter.Instruction.LDTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.LD
  alias Chip8.Interpreter.Memory
  alias Chip8.Interpreter.Timer

  describe "execute/2" do
    test "should return an interpreter with vx set to the given byte" do
      interpreter = Interpreter.new()

      vx = %Register{value: :rand.uniform(0xF)}
      byte = %Byte{value: :rand.uniform(0xFF)}
      arguments = {vx, byte}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert byte.value == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with vx set to the given byte wrapped to 8 bits" do
      interpreter = Interpreter.new()

      vx = %Register{value: :rand.uniform(0xF)}
      value = :rand.uniform(0xFF)
      byte = %Byte{value: 0xFF + value}
      arguments = {vx, byte}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert value - 1 == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with i set to the given address" do
      interpreter = Interpreter.new()

      i = Register.i()
      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {i, address}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert address.value == executed_interpreter.i
    end

    test "should return an interpreter with i set to the given address wrapped to 16 bits" do
      interpreter = Interpreter.new()

      i = Register.i()
      value = :rand.uniform(0xFFFF)
      address = %Address{value: 0xFFFF + value}
      arguments = {i, address}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert value - 1 == executed_interpreter.i
    end

    test "should return an interpreter with vx set to the delay timer" do
      interpreter = Interpreter.new()
      dt_value = :rand.uniform(0xFFF)
      dt_timer = Timer.new(dt_value)
      interpreter = put_in(interpreter.dt, dt_timer)

      vx = %Register{value: :rand.uniform(0xF)}
      dt = Register.dt()
      arguments = {vx, dt}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.v[vx.value] == dt_value
    end

    test "should return an interpreter with pc set to the previous instruction when a key is not pressed" do
      interpreter = Interpreter.new()
      pc_value = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.pc, pc_value)

      vx = %Register{value: :rand.uniform(0xF)}
      keyboard = Register.keyboard()
      arguments = {vx, keyboard}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc - 2 == executed_interpreter.pc
    end

    test "should return an interpreter with pc unchanged when a key is pressed" do
      interpreter = Interpreter.new()
      key = :rand.uniform(0xF)
      interpreter = put_in(interpreter.keyboard.keys[key], :pressed)

      vx = %Register{value: :rand.uniform(0xF)}
      keyboard = Register.keyboard()
      arguments = {vx, keyboard}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter.pc == executed_interpreter.pc
    end

    test "should return an interpreter with vx set to the key pressed when a key is pressed" do
      interpreter = Interpreter.new()
      key = :rand.uniform(0xF)
      interpreter = put_in(interpreter.keyboard.keys[key], :pressed)

      vx = %Register{value: :rand.uniform(0xF)}
      keyboard = Register.keyboard()
      arguments = {vx, keyboard}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert key == executed_interpreter.v[vx.value]
    end

    test "should return an interpreter with delay timer set to the vx" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.v[x], x_value)

      dt = Register.dt()
      vx = %Register{value: x}
      arguments = {dt, vx}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.dt.value == x_value
    end

    test "should return an interpreter with sound timer set to the vx" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.v[x], x_value)

      st = Register.st()
      vx = %Register{value: x}
      arguments = {st, vx}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert executed_interpreter.st.value == x_value
    end

    test "should return an interpreter with i set to the address of the character set in vx" do
      interpreter = Interpreter.new()
      x = :rand.uniform(0xF)
      x_value = 0xD
      interpreter = put_in(interpreter.v[x], x_value)

      font = Register.font()
      vx = %Register{value: x}
      arguments = {font, vx}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0x91 == executed_interpreter.i
    end

    test "should return an interpreter with memory holding the decimal digits of vy" do
      interpreter = Interpreter.new()

      i_value = 0xFFA
      interpreter = put_in(interpreter.i, i_value)
      x = :rand.uniform(0xF)
      x_value = 0xE0
      interpreter = put_in(interpreter.v[x], x_value)

      bcd = Register.bcd()
      vx = %Register{value: x}
      arguments = {bcd, vx}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert [2, 2, 4] == Memory.read(executed_interpreter.memory, i_value, 3)
    end

    test "should return an interpreter with memory holding the contents of v register 0 up to vy" do
      interpreter = Interpreter.new()

      x = :rand.uniform(0xE) + 1
      interpreter = Enum.reduce(0..x, interpreter, &put_in(&2.v[&1], &1))
      i_value = :rand.uniform(interpreter.memory.size - x)
      interpreter = put_in(interpreter.i, i_value)

      memory = Register.memory()
      vx = %Register{value: x}
      arguments = {memory, vx}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter

      assert Enum.to_list(0..vx.value) ==
               Memory.read(executed_interpreter.memory, i_value, vx.value + 1)
    end

    test "should return an interpreter with v register 0 up to vx holding the contents of memory" do
      interpreter = Interpreter.new()

      x = :rand.uniform(0xE) + 1
      address = :rand.uniform(interpreter.memory.size - x)
      interpreter = put_in(interpreter.i, address)
      data = Enum.to_list(1..x)
      memory = Memory.write(interpreter.memory, address, data)
      interpreter = put_in(interpreter.memory, memory)

      vx = %Register{value: x}
      memory = Register.memory()
      arguments = {vx, memory}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter

      assert data
             |> Enum.with_index()
             |> Enum.all?(fn {value, index} ->
               value == executed_interpreter.v[index]
             end)
    end

    test "should return an interpreter with vx set to vy" do
      interpreter = Interpreter.new()
      y = 0xE
      y_value = 0x580
      interpreter = put_in(interpreter.v[y], y_value)

      vx = %Register{value: 0xF}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_interpreter = LD.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert y_value == executed_interpreter.v[vx.value]
    end
  end
end
