defmodule Chip8.Instruction.SUBNTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SUBN
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with vx set to the difference of vy and vx when vy is larger than vx" do
      runtime = Runtime.new()
      x = 0xC
      x_value = 0x83
      runtime = put_in(runtime.v[x], x_value)
      y = 0x1
      y_value = 0xE5
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x62 == executed_runtime.v[x]
    end

    test "should return a runtime with vx set to the difference of vy and vx when vy is equals to vx" do
      runtime = Runtime.new()
      x = 0xC
      y = 0x4
      value = 0x67
      runtime = put_in(runtime.v[x], value)
      runtime = put_in(runtime.v[y], value)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x0 == executed_runtime.v[x]
    end

    test "should return a runtime with vx set to the difference of vy and vx when vy is less than vx" do
      runtime = Runtime.new()
      x = 0x0
      x_value = 0xB6
      runtime = put_in(runtime.v[x], x_value)
      y = 0x7
      y_value = 0x63
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x53 == executed_runtime.v[x]
    end

    test "should return a runtime with v register F set to 1 when vy is greather than vx" do
      runtime = Runtime.new()
      x = 0xE
      x_value = 0x19
      runtime = put_in(runtime.v[x], x_value)
      y = 0x9
      y_value = 0x90
      runtime = put_in(runtime.v[y], y_value)

      arguments = %{x: x, y: y}
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

      arguments = %{x: x, y: y}
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

      arguments = %{x: x, y: y}
      executed_runtime = SUBN.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0 == executed_runtime.v[0xF]
    end
  end
end
