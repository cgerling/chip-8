defmodule Chip8.Interpreter.Instruction.RETTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.RET
  alias Chip8.Stack

  describe "execute/2" do
    test "should return an interpreter with pc set to the last item in the stack" do
      interpreter = Interpreter.new()
      address = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.stack.data, [address])
      interpreter = put_in(interpreter.stack.size, 1)

      arguments = {}
      executed_interpreter = RET.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert address == executed_interpreter.pc
    end

    test "should return an interpreter with stack without the last item" do
      interpreter = Interpreter.new()
      address = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.stack.data, [address])
      interpreter = put_in(interpreter.stack.size, 1)

      arguments = {}
      executed_interpreter = RET.execute(interpreter, arguments)

      empty_stack = Stack.new()

      assert %Interpreter{} = executed_interpreter
      assert empty_stack == executed_interpreter.stack
    end

    test "should return an interpreter unchanged when stack is empty" do
      interpreter = Interpreter.new()

      arguments = {}
      executed_interpreter = RET.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter == executed_interpreter
    end
  end
end
