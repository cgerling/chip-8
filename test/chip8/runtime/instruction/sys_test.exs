defmodule Chip8.Runtime.Instruction.SYSTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Runtime.Instruction.SYS

  describe "execute/2" do
    test "should return runtime data unchanged" do
      runtime = Runtime.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_runtime = SYS.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime == executed_runtime
    end
  end
end
