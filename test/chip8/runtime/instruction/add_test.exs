defmodule Chip8.Runtime.Instruction.ADDTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.ADD
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Register

  describe "execute/2" do
    test "should return a runtime with vx set to the sum of vx and the given byte" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0xF8
      runtime = put_in(runtime.v[x], x_value)

      vx = %Register{value: x}
      byte = %Byte{value: 0x2B}
      arguments = {vx, byte}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x23 == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the sum of vx and the given byte wrapped to 8 bits" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = 0xE9
      runtime = put_in(runtime.v[x], x_value)

      vx = %Register{value: x}
      byte = %Byte{value: 0xD4}
      arguments = {vx, byte}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xBD == executed_runtime.v[vx.value]
    end

    test "should return a runtime with i set to the sum of i and vx" do
      runtime = Runtime.new()
      i_value = 0x64
      runtime = put_in(runtime.i, i_value)
      x = 0xC
      x_value = 0x2C
      runtime = put_in(runtime.v[x], x_value)

      i = Register.i()
      vx = %Register{value: x}
      arguments = {i, vx}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x90 == executed_runtime.i
    end

    test "should return a runtime with i set to the sum of i and vy wrapped to 16 bits" do
      runtime = Runtime.new()
      i_value = 0xFF36
      runtime = put_in(runtime.i, i_value)
      x = 0xC
      x_value = 0xE5
      runtime = put_in(runtime.v[x], x_value)

      i = Register.i()
      vx = %Register{value: x}
      arguments = {i, vx}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x1B == executed_runtime.i
    end

    test "should return a runtime with vx set to the sum of vx and vy" do
      runtime = Runtime.new()
      x = 0x9
      x_value = 0x2C
      runtime = put_in(runtime.v[x], x_value)
      y = 0xD
      y_value = 0x84
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xB0 == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the sum of vx and vy wrapped to 8 bits" do
      runtime = Runtime.new()
      x = 0x9
      x_value = 0xAC
      runtime = put_in(runtime.v[x], x_value)
      y = 0xD
      y_value = 0x90
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = ADD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x3C == executed_runtime.v[vx.value]
    end
  end
end
