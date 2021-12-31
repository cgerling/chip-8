defmodule Chip8.Instruction.LDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.LD
  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      arguments = %{x: x, operation: :bcd}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with memory holding the decimal digits of v register x" do
      runtime = Runtime.new()

      i_value = 0xFFA
      x = :rand.uniform(0xF)
      x_value = 0xE0
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.i, i_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, operation: :bcd}
      executed_runtime = LD.execute(runtime, arguments)

      assert [2, 2, 4] == Memory.read(executed_runtime.memory, i_value, 3)
    end

    test "should return a runtime with memory holding the contents of v register 0 up to v register x" do
      runtime = Runtime.new()

      x = :rand.uniform(0xE) + 1
      i_value = :rand.uniform(runtime.memory.size - x)
      v_registers = Enum.reduce(0..x, runtime.v, &VRegisters.set(&2, &1, &1))
      runtime = put_in(runtime.i, i_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, operation: :store, to: :memory}
      executed_runtime = LD.execute(runtime, arguments)

      assert Enum.to_list(0..x) == Memory.read(executed_runtime.memory, i_value, x + 1)
    end

    test "should return a runtime with v register 0 up to v register x holding the contents of memory" do
      runtime = Runtime.new()

      x = :rand.uniform(0xE) + 1
      data = Enum.to_list(1..x)
      address = :rand.uniform(runtime.memory.size - x)
      memory = Memory.write(runtime.memory, address, data)
      runtime = put_in(runtime.i, address)
      runtime = put_in(runtime.memory, memory)

      arguments = %{x: x, operation: :load, from: :memory}
      executed_runtime = LD.execute(runtime, arguments)

      assert data
             |> Enum.with_index()
             |> Enum.all?(fn {value, index} ->
               value == VRegisters.get(executed_runtime.v, index)
             end)
    end

    test "should return a runtime with v register x set to the given byte" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      byte = :rand.uniform(0xFF)
      arguments = %{x: x, byte: byte}
      executed_runtime = LD.execute(runtime, arguments)

      assert byte == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with v register x set to v register y" do
      runtime = Runtime.new()
      x = 0xF
      y = 0xE
      y_value = 0x580
      v_registers = VRegisters.set(runtime.v, y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = LD.execute(runtime, arguments)

      assert y_value == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with i set to the given address" do
      runtime = Runtime.new()

      address = :rand.uniform(0xFFF)
      arguments = %{address: address}
      executed_runtime = LD.execute(runtime, arguments)

      assert address == executed_runtime.i
    end

    test "should return a runtime with i set to the address of the character set in v register x" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0xD
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x}
      executed_runtime = LD.execute(runtime, arguments)

      assert 0x91 == executed_runtime.i
    end

    test "should return a runtime with v register x set to the delay timer" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      dt_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.dt, dt_value)

      arguments = %{x: x, operation: :store, from: :dt}
      executed_runtime = LD.execute(runtime, arguments)

      assert dt_value == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with delay timer set to the v register x" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, operation: :store, to: :dt}
      executed_runtime = LD.execute(runtime, arguments)

      assert x_value == executed_runtime.dt
    end

    test "should return a runtime with pc set to the previous instruction when a key is not pressed" do
      runtime = Runtime.new()
      pc_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.pc, pc_value)

      x = :rand.uniform(0xF)
      arguments = %{x: x, operation: :store, from: :keyboard}
      executed_runtime = LD.execute(runtime, arguments)

      assert runtime.pc - 2 == executed_runtime.pc
    end

    test "should return a runtime with pc unchanged when a key is pressed" do
      runtime = Runtime.new()
      key = :rand.uniform(0xF)
      runtime = put_in(runtime.keyboard.keys[key], :pressed)

      x = :rand.uniform(0xF)
      arguments = %{x: x, operation: :store, from: :keyboard}
      executed_runtime = LD.execute(runtime, arguments)

      assert runtime.pc == executed_runtime.pc
    end

    test "should return a runtime with v register x set to the key pressed when a key is pressed" do
      runtime = Runtime.new()
      key = :rand.uniform(0xF)
      runtime = put_in(runtime.keyboard.keys[key], :pressed)

      x = :rand.uniform(0xF)
      arguments = %{x: x, operation: :store, from: :keyboard}
      executed_runtime = LD.execute(runtime, arguments)

      assert key == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with sound timer set to the v register x" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, operation: :store, to: :st}
      executed_runtime = LD.execute(runtime, arguments)

      assert x_value == executed_runtime.st
    end
  end
end
