defmodule Chip8.Instruction.JPTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.JP
  alias Chip8.Runtime
  alias Chip8.VRegisters

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

    test "should return a runtime with pc set to the sum of v register 0 and the given address" do
      runtime = Runtime.new()
      register_value = :rand.uniform(0xFFF)
      v_registers = VRegisters.set(runtime.v, 0x0, register_value)
      runtime = put_in(runtime.v, v_registers)

      address = :rand.uniform(0xFF)
      arguments = %{x: 0, address: address}
      executed_runtime = JP.execute(runtime, arguments)

      assert register_value + address == executed_runtime.pc
    end
  end
end
