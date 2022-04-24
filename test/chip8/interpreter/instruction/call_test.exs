defmodule Chip8.Interpreter.Instruction.CALLTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.CALL

  describe "execute/2" do
    test "should return an interpreter with pc set to the given address" do
      interpreter = Interpreter.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_interpreter = CALL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert address.value == executed_interpreter.pc
    end

    test "should return an interpreter with stack last item as the previous pc" do
      interpreter = Interpreter.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_interpreter = CALL.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert [interpreter.pc] == executed_interpreter.stack.data
      assert 1 == executed_interpreter.stack.size
    end
  end
end
