defmodule Chip8.Instruction.SUBNTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SUBN
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register x set to the difference of v register y and v register x when v register y is larger than v register x" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0x83
      y = 0x1
      y_value = 0xE5
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x62 == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with v register x set to the difference of v register y and v register x when v register y is equals to v register x" do
      runtime = Runtime.new()
      x = 0xC
      y = 0x4
      value = 0x67
      v_registers = runtime.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0 == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with v register x set to the difference of v register y and v register x when v register y is less than v register x" do
      runtime = Runtime.new()
      x = 0x0
      x_value = 0xB6
      y = 0x7
      y_value = 0x63
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x53 == VRegisters.get(executed_runtime.v, x)
    end

    test "should return a runtime with v register F set to 1 when v register y is greather than v register x" do
      runtime = Runtime.new()
      x = 0xE
      x_value = 0x19
      y = 0x9
      y_value = 0x90
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == VRegisters.get(executed_runtime.v, 0xF)
    end

    test "should return a runtime with v register F set to 0 when v register y is equals to v register x" do
      runtime = Runtime.new()
      x = 0xF
      y = 0xC
      value = 0xA0
      v_registers = runtime.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == VRegisters.get(executed_runtime.v, 0xF)
    end

    test "should return a runtime with v register F set to 0 when v register y is less than v register x" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0x8B
      y = 0x5
      y_value = 0x07
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == VRegisters.get(executed_runtime.v, 0xF)
    end
  end
end
