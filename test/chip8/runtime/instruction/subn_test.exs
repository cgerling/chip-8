defmodule Chip8.Runtime.Instruction.SUBNTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.SUBN

  describe "execute/2" do
    test "should return a runtime with vx set to the difference of vy and vx wrapped to 8 bits when vy is larger than vx" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0x83
      runtime = put_in(runtime.v[x], x_value)
      y = 0x1
      y_value = 0xE5
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x62 == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the difference of vy and vx wrapped to 8 bits when vy is equals to vx" do
      runtime = Runtime.new()
      x = 0xC
      y = 0x4
      value = 0x67
      runtime = put_in(runtime.v[x], value)
      runtime = put_in(runtime.v[y], value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0 == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to the difference of vy and vx wrapped to 8 bits when vy is less than vx" do
      runtime = Runtime.new()
      x = 0x0
      x_value = 0xB6
      runtime = put_in(runtime.v[x], x_value)
      y = 0x7
      y_value = 0x63
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xAD == executed_runtime.v[vx.value]
    end

    test "should return a runtime with v register F set to 1 when vy is greather than vx" do
      runtime = Runtime.new()
      x = 0xE
      x_value = 0x19
      runtime = put_in(runtime.v[x], x_value)
      y = 0x9
      y_value = 0x90
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register F set to 0 when vy is equals to vx" do
      runtime = Runtime.new()
      x = 0xF
      y = 0xC
      value = 0xA0
      runtime = put_in(runtime.v[x], value)
      runtime = put_in(runtime.v[y], value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register F set to 0 when vy is less than vx" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0x8B
      runtime = put_in(runtime.v[x], x_value)
      y = 0x5
      y_value = 0x07
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: x}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end
  end
end
