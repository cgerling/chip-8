defmodule Chip8.Interpreter.Instruction.SYSTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.SYS

  describe "execute/2" do
    test "should return an interpreter unchanged" do
      interpreter = Interpreter.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_interpreter = SYS.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert interpreter == executed_interpreter
    end
  end
end
