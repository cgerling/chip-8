defmodule Chip8.Instruction.RETTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.RET
  alias Chip8.Runtime
  alias Chip8.Stack

  describe "execute/2" do
    test "should return a runtime with pc set to the last item in the stack" do
      runtime = Runtime.new()
      address = :rand.uniform(0xFFF)
      runtime = put_in(runtime.stack.data, [address])
      runtime = put_in(runtime.stack.size, 1)

      arguments = %{}
      executed_runtime = RET.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert address == executed_runtime.pc
    end

    test "should return a runtime with stack without the last item" do
      runtime = Runtime.new()
      address = :rand.uniform(0xFFF)
      runtime = put_in(runtime.stack.data, [address])
      runtime = put_in(runtime.stack.size, 1)

      arguments = %{}
      executed_runtime = RET.execute(runtime, arguments)

      empty_stack = Stack.new()

      assert %Runtime{} = executed_runtime
      assert empty_stack == executed_runtime.stack
    end

    test "should return a runtime unchanged when stack is empty" do
      runtime = Runtime.new()

      arguments = %{}
      executed_runtime = RET.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime == executed_runtime
    end
  end
end
