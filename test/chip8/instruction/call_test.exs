defmodule Chip8.Instruction.CALLTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.CALL
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime with pc set to the given address" do
      runtime = Runtime.new()

      address = :rand.uniform(0xFFF)
      arguments = %{address: address}
      executed_runtime = CALL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert address == executed_runtime.pc
    end

    test "should return a runtime with stack last item as the previous pc" do
      runtime = Runtime.new()

      address = :rand.uniform(0xFFF)
      arguments = %{address: address}
      executed_runtime = CALL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert [runtime.pc] == executed_runtime.stack.data
      assert 1 == executed_runtime.stack.size
    end
  end
end
