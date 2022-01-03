defmodule Chip8.Instruction.SUBTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SUB
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime with v register x set to the difference of v register x and v register y when v register x is larger than v register y" do
      runtime = Runtime.new()
      x = 0x5
      x_value = 0x36
      y = 0x0
      y_value = 0x29
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0D == executed_runtime.v[x]
    end

    test "should return a runtime with v register x set to the difference of v register x and v register y when v register x is equals to v register y" do
      runtime = Runtime.new()
      x = 0xB
      y = 0x2
      value = 0x25
      v_registers = runtime.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0 == executed_runtime.v[x]
    end

    test "should return a runtime with v register x set to the difference of v register x and v register y when v register x is less than v register y" do
      runtime = Runtime.new()
      x = 0xB
      x_value = 0x1D
      y = 0x2
      y_value = 0xE3
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xC6 == executed_runtime.v[x]
    end

    test "should return a runtime with v register F set to 1 when v register x is greather than v register y" do
      runtime = Runtime.new()
      x = 0x3
      x_value = 0xD5
      y = 0xF
      y_value = 0x9F
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register F set to 0 when v register x is equals to v register y" do
      runtime = Runtime.new()
      x = 0xC
      y = 0x5
      value = 0x19
      v_registers = runtime.v |> VRegisters.set(x, value) |> VRegisters.set(y, value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register F set to 0 when v register x is less than v register y" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0xBC
      y = 0x5
      y_value = 0xF4
      v_registers = runtime.v |> VRegisters.set(x, x_value) |> VRegisters.set(y, y_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end
  end
end
