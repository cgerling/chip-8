defmodule Chip8.Instruction.LDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.Argument.Address
  alias Chip8.Instruction.Argument.Byte
  alias Chip8.Instruction.Argument.Register
  alias Chip8.Instruction.LD
  alias Chip8.Memory
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with memory holding the decimal digits of vy" do
      runtime = Runtime.new()

      i_value = 0xFFA
      runtime = put_in(runtime.i, i_value)
      x = :rand.uniform(0xF)
      x_value = 0xE0
      runtime = put_in(runtime.v[x], x_value)

      bcd = Register.bcd()
      vx = %Register{value: x}
      arguments = {bcd, vx}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert [2, 2, 4] == Memory.read(executed_runtime.memory, i_value, 3)
    end

    test "should return a runtime with memory holding the contents of v register 0 up to vy" do
      runtime = Runtime.new()

      y = :rand.uniform(0xE) + 1
      runtime = Enum.reduce(0..y, runtime, &put_in(&2.v[&1], &1))
      i_value = :rand.uniform(runtime.memory.size - y)
      runtime = put_in(runtime.i, i_value)

      arguments = %{x: :memory, y: y}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert Enum.to_list(0..y) == Memory.read(executed_runtime.memory, i_value, y + 1)
    end

    test "should return a runtime with v register 0 up to vx holding the contents of memory" do
      runtime = Runtime.new()

      x = :rand.uniform(0xE) + 1
      address = :rand.uniform(runtime.memory.size - x)
      runtime = put_in(runtime.i, address)
      data = Enum.to_list(1..x)
      memory = Memory.write(runtime.memory, address, data)
      runtime = put_in(runtime.memory, memory)

      arguments = %{x: x, y: :memory}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime

      assert data
             |> Enum.with_index()
             |> Enum.all?(fn {value, index} ->
               value == executed_runtime.v[index]
             end)
    end

    test "should return a runtime with vx set to the delay timer" do
      runtime = Runtime.new()
      dt_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.dt, dt_value)

      vx = %Register{value: :rand.uniform(0xF)}
      dt = Register.dt()
      arguments = {vx, dt}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert dt_value == executed_runtime.v[vx.value]
    end

    test "should return a runtime with delay timer set to the vx" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.v[x], x_value)

      dt = Register.dt()
      vx = %Register{value: x}
      arguments = {dt, vx}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert x_value == executed_runtime.dt
    end

    test "should return a runtime with sound timer set to the vx" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.v[x], x_value)

      st = Register.st()
      vx = %Register{value: x}
      arguments = {st, vx}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert x_value == executed_runtime.st
    end

    test "should return a runtime with pc set to the previous instruction when a key is not pressed" do
      runtime = Runtime.new()
      pc_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.pc, pc_value)

      vx = %Register{value: :rand.uniform(0xF)}
      keyboard = Register.keyboard()
      arguments = {vx, keyboard}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc - 2 == executed_runtime.pc
    end

    test "should return a runtime with pc unchanged when a key is pressed" do
      runtime = Runtime.new()
      key = :rand.uniform(0xF)
      runtime = put_in(runtime.keyboard.keys[key], :pressed)

      vx = %Register{value: :rand.uniform(0xF)}
      keyboard = Register.keyboard()
      arguments = {vx, keyboard}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc == executed_runtime.pc
    end

    test "should return a runtime with vx set to the key pressed when a key is pressed" do
      runtime = Runtime.new()
      key = :rand.uniform(0xF)
      runtime = put_in(runtime.keyboard.keys[key], :pressed)

      vx = %Register{value: :rand.uniform(0xF)}
      keyboard = Register.keyboard()
      arguments = {vx, keyboard}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert key == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to vy" do
      runtime = Runtime.new()
      y = 0xE
      y_value = 0x580
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: 0xF}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert y_value == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the given byte" do
      runtime = Runtime.new()

      vx = %Register{value: :rand.uniform(0xF)}
      byte = %Byte{value: :rand.uniform(0xFF)}
      arguments = {vx, byte}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert byte.value == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the given byte wrapped to 8 bits" do
      runtime = Runtime.new()

      vx = %Register{value: :rand.uniform(0xF)}
      value = :rand.uniform(0xFF)
      byte = %Byte{value: 0xFF + value}
      arguments = {vx, byte}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert value - 1 == executed_runtime.v[vx.value]
    end

    test "should return a runtime with i set to the given address" do
      runtime = Runtime.new()

      i = Register.i()
      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {i, address}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert address.value == executed_runtime.i
    end

    test "should return a runtime with i set to the given address wrapped to 16 bits" do
      runtime = Runtime.new()

      i = Register.i()
      value = :rand.uniform(0xFFFF)
      address = %Address{value: 0xFFFF + value}
      arguments = {i, address}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert value - 1 == executed_runtime.i
    end

    test "should return a runtime with i set to the address of the character set in vx" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0xD
      runtime = put_in(runtime.v[x], x_value)

      font = Register.font()
      vx = %Register{value: x}
      arguments = {font, vx}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x91 == executed_runtime.i
    end
  end
end
