defmodule Chip8.Runtime.Instruction.JPTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.JP
  alias Chip8.Runtime.VRegisters

  describe "execute/2" do
    test "should return a runtime with pc set to the given address" do
      runtime = Runtime.new()

      address = %Address{value: :rand.uniform(0xFFF)}
      arguments = {address}
      executed_runtime = JP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert address.value == executed_runtime.pc
    end

    test "should return a runtime with pc set to the given address wrapped to 12 bits" do
      runtime = Runtime.new()

      value = :rand.uniform(0xFFF)
      address = %Address{value: 0xFFF + value}
      arguments = {address}
      executed_runtime = JP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert value - 1 == executed_runtime.pc
    end

    test "should return a runtime with pc set to the sum of v register 0 and the given address" do
      runtime = Runtime.new()
      register_value = :rand.uniform(0xFF)
      v_registers = VRegisters.set(runtime.v, 0x0, register_value)
      runtime = put_in(runtime.v, v_registers)

      v0 = Register.v(0x0)
      address = %Address{value: :rand.uniform(0xFFF) - register_value}
      arguments = {v0, address}
      executed_runtime = JP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert register_value + address.value == executed_runtime.pc
    end

    test "should return a runtime with pc set to the sum of v register 0 and the given address wrapped to 12 bits" do
      runtime = Runtime.new()
      register_value = 0xF1F
      v_registers = VRegisters.set(runtime.v, 0x0, register_value)
      runtime = put_in(runtime.v, v_registers)

      v0 = Register.v(0x0)
      address = %Address{value: 0x9E3}
      arguments = {v0, address}
      executed_runtime = JP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert 0x902 == executed_runtime.pc
    end
  end
end
