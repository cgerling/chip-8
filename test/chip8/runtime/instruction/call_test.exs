defmodule Chip8.Runtime.Instruction.CALLTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Runtime.Instruction.CALL

  describe "execute/2" do
    test "should return a runtime with pc set to the given address" do
      runtime = Runtime.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_runtime = CALL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert address.value == executed_runtime.pc
    end

    test "should return a runtime with stack last item as the previous pc" do
      runtime = Runtime.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_runtime = CALL.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert [runtime.pc] == executed_runtime.stack.data
      assert 1 == executed_runtime.stack.size
    end
  end
end
