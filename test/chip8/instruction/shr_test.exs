defmodule Chip8.Instruction.SHRTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.Argument.Register
  alias Chip8.Instruction.SHR
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with v register F set to the least significant bit of vy" do
      runtime = Runtime.new()
      y = 0x2
      y_value = 0x85
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: 0xA}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SHR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 1 == executed_runtime.v[0xF]
    end

    test "should return a runtime with vx set to vy shifted one bit to the right" do
      runtime = Runtime.new()
      y = 0x3
      y_value = 0xAD
      runtime = put_in(runtime.v[y], y_value)

      vx = %Register{value: 0xC}
      vy = %Register{value: y}
      arguments = {vx, vy}
      executed_runtime = SHR.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x56 == executed_runtime.v[vx.value]
    end
  end
end
