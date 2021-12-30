defmodule Chip8.Instruction.LDTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction.LD
  alias Chip8.Memory
  alias Chip8.Runtime
  alias Chip8.VRegisters

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      x = :rand.uniform(0xF)
      arguments = %{x: x, operation: :bcd}
      executed_runtime = LD.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime with memory holding the decimal digits of v register x" do
      runtime = Runtime.new()

      i_value = 0xFFA
      x = :rand.uniform(0xF)
      x_value = 0xE0
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.i, i_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, operation: :bcd}
      executed_runtime = LD.execute(runtime, arguments)

      assert [2, 2, 4] == Memory.read(executed_runtime.memory, i_value, 3)
    end

    test "should return a runtime with memory holding the contents of v register 0 up to v register x" do
      runtime = Runtime.new()

      x = :rand.uniform(0xE) + 1
      i_value = :rand.uniform(runtime.memory.size - x)
      v_registers = Enum.reduce(0..x, runtime.v, &VRegisters.set(&2, &1, &1))
      runtime = put_in(runtime.i, i_value)
      runtime = put_in(runtime.v, v_registers)

      arguments = %{x: x, operation: :store}
      executed_runtime = LD.execute(runtime, arguments)

      assert Enum.to_list(0..x) == Memory.read(executed_runtime.memory, i_value, x + 1)
    end
  end
end
