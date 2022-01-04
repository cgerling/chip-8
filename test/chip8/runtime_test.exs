defmodule Chip8.RuntimeTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction
  alias Chip8.Runtime

  @instruction_size Instruction.byte_size()

  describe "new/0" do
    test "should return a runtime struct" do
      system = Runtime.new()

      assert %Runtime{} = system
    end
  end

  describe "to_next_instruction/1" do
    test "should return a runtime struct with pc set to the next instruction address" do
      runtime = Runtime.new()
      pc_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.pc, pc_value)

      next_instruction_runtime = Runtime.to_next_instruction(runtime)

      assert %Runtime{} = next_instruction_runtime
      assert pc_value + @instruction_size == next_instruction_runtime.pc
    end
  end

  describe "to_previous_instruction/1" do
    test "should return a runtime struct with pc set to the previous instruction address" do
      runtime = Runtime.new()
      pc_value = :rand.uniform(0xFFF)
      runtime = put_in(runtime.pc, pc_value)

      previous_instruction_runtime = Runtime.to_previous_instruction(runtime)

      assert %Runtime{} = previous_instruction_runtime
      assert pc_value - @instruction_size == previous_instruction_runtime.pc
    end
  end
end
