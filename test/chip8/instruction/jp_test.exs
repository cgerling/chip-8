defmodule Chip8.Instruction.JPTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.JP
  alias Chip8.Runtime

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      address = :rand.uniform(0xF)
      arguments = %{address: address}
      executed_runtime = JP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with pc set to the given address" do
      runtime = Runtime.new()

      address = :rand.uniform(0xFFF)
      arguments = %{address: address}
      executed_runtime = JP.execute(runtime, arguments)

      assert address == executed_runtime.pc
    end
  end
end
