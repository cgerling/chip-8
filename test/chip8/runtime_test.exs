defmodule Chip8.RuntimeTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Font
  alias Chip8.Runtime.Instruction
  alias Chip8.Runtime.Memory

  @instruction_size Instruction.byte_size()

  describe "new/0" do
    test "should return a runtime initialized" do
      runtime = Runtime.new()

      assert %Runtime{} = runtime
      assert 0x200 == runtime.pc
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

  describe "load_font/2" do
    test "should return a runtime with font data loaded on memory" do
      runtime = Runtime.new()

      font_address = 0x050
      font_data = Font.data()
      font_size = Enum.count(font_data)

      loaded_runtime = Runtime.load_font(runtime, font_data)

      assert %Runtime{} = loaded_runtime
      assert Memory.read(loaded_runtime.memory, font_address, font_size) == font_data
    end
  end

  describe "load_program/2" do
    test "should return a runtime struct with program data loaded on memory" do
      runtime = Runtime.new()
      program = [0x6A, 0x95, 0x27, 0x76, 0x38, 0x78, 0x25, 0x82]

      loaded_runtime = Runtime.load_program(runtime, program)

      assert %Runtime{} = loaded_runtime
      assert Memory.read(loaded_runtime.memory, 0x200, 8) == program
    end
  end

  describe "run_cycle/1" do
    test "should return a runtime struct after executing the current instruction" do
      runtime = Runtime.new()
      jp_bytes = [0x1B, 0xF0]
      memory = Memory.write(runtime.memory, runtime.pc, jp_bytes)
      runtime = put_in(runtime.memory, memory)

      runned_runtime = Runtime.run_cycle(runtime)

      assert %Runtime{} = runned_runtime
      assert 0xBF0 == runned_runtime.pc
    end

    test "should return a runtime struct with pc set to the next instruction address" do
      runtime = Runtime.new()

      runned_runtime = Runtime.run_cycle(runtime)

      assert %Runtime{} = runned_runtime
      assert runtime.pc + @instruction_size == runned_runtime.pc
    end
  end
end
