defmodule Chip8.Instruction.SUBTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SUB
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with vx set to the difference of vx and vy wrapped to 8 bits when vx is larger than vy" do
      runtime = Runtime.new()
      x = 0x5
      x_value = 0x36
      runtime = put_in(runtime.v[x], x_value)
      y = 0x0
      y_value = 0x29
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0D == executed_runtime.v[x]
    end

    test "should return a runtime with vx set to the difference of vx and vy wrapped to 8 bits when vx is equals to vy wrapped to 8 bits" do
      runtime = Runtime.new()
      x = 0xB
      y = 0x2
      value = 0x25
      runtime = put_in(runtime.v[x], value)
      runtime = put_in(runtime.v[y], value)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0 == executed_runtime.v[x]
    end

    test "should return a runtime with vx set to the difference of vx and vy wrapped to 8 bits when vx is less than vy wrapped to 8 bits" do
      runtime = Runtime.new()
      x = 0xB
      x_value = 0x1D
      runtime = put_in(runtime.v[x], x_value)
      y = 0x2
      y_value = 0xE3
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x3A == executed_runtime.v[x]
    end

    test "should return a runtime with v register F set to 1 when vx is greather than vy" do
      runtime = Runtime.new()
      x = 0x3
      x_value = 0xD5
      runtime = put_in(runtime.v[x], x_value)
      y = 0xF
      y_value = 0x9F
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register F set to 0 when vx is equals to vy" do
      runtime = Runtime.new()
      x = 0xC
      y = 0x5
      value = 0x19
      runtime = put_in(runtime.v[x], value)
      runtime = put_in(runtime.v[y], value)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end

    test "should return a runtime with v register F set to 0 when vx is less than vy" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0xBC
      runtime = put_in(runtime.v[x], x_value)
      y = 0x5
      y_value = 0xF4
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = SUB.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end
  end
end
