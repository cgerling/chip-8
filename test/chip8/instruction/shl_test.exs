defmodule Chip8.Instruction.SHLTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.Argument.Register
  alias Chip8.Instruction.SHL
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with v register F set to the most significant bit of vy" do
      runtime = Runtime.new()
      y = 0x0
      y_value = 0xF7
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: 0x8}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SHL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with vx set to vy shifted one bit to the left" do
      runtime = Runtime.new()
      y = 0x5
      y_value = 0x45
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: 0x9}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SHL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x8A == executed_runtime.v[vx.value]
    end

    test "should return a runtime with vx set to vy shifted one bit to the left wrapped to 8 bits" do
      runtime = Runtime.new()
      y = 0x5
      y_value = 0xD5
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: 0x9}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SHL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0xAA == executed_runtime.v[vx.value]
    end
  end
end
