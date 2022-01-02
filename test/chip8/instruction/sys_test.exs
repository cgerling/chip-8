defmodule Chip8.Instruction.SYSTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.SYS
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return runtime data unchanged" do
      runtime = Runtime.new()

      address = :rand.uniform(0xFFF)
      arguments = %{address: address}
      executed_runtime = SYS.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime == executed_runtime
    end
  end
end
