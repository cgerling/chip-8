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

    test "should return a runtime struct with pc set to the next instruction address wrapped to 12 bits" do
      runtime = Runtime.new()
      pc_value = 0xFFF
      runtime = put_in(runtime.pc, pc_value)

      next_instruction_runtime = Runtime.to_next_instruction(runtime)

      assert %Runtime{} = next_instruction_runtime
      assert 1 == next_instruction_runtime.pc
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

    test "should return a runtime struct with pc set to the previous instruction address wrapped to 12 bits" do
      runtime = Runtime.new()
      pc_value = 0x0
      runtime = put_in(runtime.pc, pc_value)

      previous_instruction_runtime = Runtime.to_previous_instruction(runtime)

      assert %Runtime{} = previous_instruction_runtime
      assert 4094 == previous_instruction_runtime.pc
    end
  end

  describe "get_font_character_address/1" do
    test "should return a memory address for all characters based on the given address" do
      characters_with_address = [
        {0x0, 0x050},
        {0x1, 0x055},
        {0x2, 0x05A},
        {0x3, 0x05F},
        {0x4, 0x064},
        {0x5, 0x069},
        {0x6, 0x06E},
        {0x7, 0x073},
        {0x8, 0x078},
        {0x9, 0x07D},
        {0xA, 0x082},
        {0xB, 0x087},
        {0xC, 0x08C},
        {0xD, 0x091},
        {0xE, 0x096},
        {0xF, 0x09B}
      ]

      for {character, character_address} <- characters_with_address do
        address = Runtime.get_font_character_address(character)

        assert is_integer(address)
        assert character_address == address
      end
    end
  end
end
