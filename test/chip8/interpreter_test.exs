defmodule Chip8.InterpreterTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Font
  alias Chip8.Interpreter.Instruction
  alias Chip8.Interpreter.Memory
  alias Chip8.Interpreter.Timer

  @instruction_size Instruction.byte_size()

  describe "new/0" do
    test "should return an interpreter initialized" do
      interpreter = Interpreter.new()

      assert %Interpreter{} = interpreter
      assert 0x200 == interpreter.pc
    end
  end

  describe "to_next_instruction/1" do
    test "should return an interpreter struct with pc set to the next instruction address" do
      interpreter = Interpreter.new()
      pc_value = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.pc, pc_value)

      next_instruction_interpreter = Interpreter.to_next_instruction(interpreter)

      assert %Interpreter{} = next_instruction_interpreter
      assert pc_value + @instruction_size == next_instruction_interpreter.pc
    end

    test "should return an interpreter struct with pc set to the next instruction address wrapped to 12 bits" do
      interpreter = Interpreter.new()
      pc_value = 0xFFF
      interpreter = put_in(interpreter.pc, pc_value)

      next_instruction_interpreter = Interpreter.to_next_instruction(interpreter)

      assert %Interpreter{} = next_instruction_interpreter
      assert 1 == next_instruction_interpreter.pc
    end
  end

  describe "to_previous_instruction/1" do
    test "should return an interpreter struct with pc set to the previous instruction address" do
      interpreter = Interpreter.new()
      pc_value = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.pc, pc_value)

      previous_instruction_interpreter = Interpreter.to_previous_instruction(interpreter)

      assert %Interpreter{} = previous_instruction_interpreter
      assert pc_value - @instruction_size == previous_instruction_interpreter.pc
    end

    test "should return an interpreter struct with pc set to the previous instruction address wrapped to 12 bits" do
      interpreter = Interpreter.new()
      pc_value = 0x0
      interpreter = put_in(interpreter.pc, pc_value)

      previous_instruction_interpreter = Interpreter.to_previous_instruction(interpreter)

      assert %Interpreter{} = previous_instruction_interpreter
      assert 4094 == previous_instruction_interpreter.pc
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
        address = Interpreter.get_font_character_address(character)

        assert is_integer(address)
        assert character_address == address
      end
    end
  end

  describe "load_font/2" do
    test "should return an interpreter with font data loaded on memory" do
      interpreter = Interpreter.new()

      font_address = 0x050
      font_data = Font.data()
      font_size = Enum.count(font_data)

      loaded_interpreter = Interpreter.load_font(interpreter, font_data)

      assert %Interpreter{} = loaded_interpreter
      assert Memory.read(loaded_interpreter.memory, font_address, font_size) == font_data
    end
  end

  describe "load_program/2" do
    test "should return an interpreter struct with program data loaded on memory" do
      interpreter = Interpreter.new()
      program = [0x6A, 0x95, 0x27, 0x76, 0x38, 0x78, 0x25, 0x82]

      loaded_interpreter = Interpreter.load_program(interpreter, program)

      assert %Interpreter{} = loaded_interpreter
      assert Memory.read(loaded_interpreter.memory, 0x200, 8) == program
    end
  end

  describe "cycle/1" do
    test "should return an interpreter struct after executing the current instruction" do
      interpreter = Interpreter.new()
      jp_bytes = [0x1B, 0xF0]
      memory = Memory.write(interpreter.memory, interpreter.pc, jp_bytes)
      interpreter = put_in(interpreter.memory, memory)

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.pc == 0xBF0
    end

    test "should return an interpreter struct with pc set to the next instruction address" do
      interpreter = Interpreter.new()

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.pc == interpreter.pc + @instruction_size
    end

    test "should return an interpreter struct with dt decremented by 1" do
      interpreter = Interpreter.new()
      dt_value = :rand.uniform(0xFFFF) + 1
      dt = Timer.new(dt_value)
      interpreter = put_in(interpreter.dt, dt)

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.dt == Timer.new(dt_value - 1)
    end

    test "should return an interpreter struct with st decremented by 1" do
      interpreter = Interpreter.new()
      st_value = :rand.uniform(0xFFFF) + 1
      st = Timer.new(st_value)
      interpreter = put_in(interpreter.st, st)

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.st == Timer.new(st_value - 1)
    end

    test "should return an interpreter struct with dt unchanged when is equals to 0" do
      interpreter = Interpreter.new()

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.dt == interpreter.dt
    end

    test "should return an interpreter struct with st unchanged when is equals to 0" do
      interpreter = Interpreter.new()

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.st == interpreter.st
    end

    test "should return an interpreter struct with dt reseted when is less than 0" do
      interpreter = Interpreter.new()
      dt = Timer.new(-1)
      interpreter = put_in(interpreter.dt, dt)

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.dt == Timer.new()
    end

    test "should return an interpreter struct with st reseted when is less than 0" do
      interpreter = Interpreter.new()
      st = Timer.new(-1)
      interpreter = put_in(interpreter.st, st)

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.st == Timer.new()
    end

    test "should return an error when the current instruction is invalid" do
      interpreter = Interpreter.new()
      invalid_bytes = [0xFF, 0xFF]
      memory = Memory.write(interpreter.memory, interpreter.pc, invalid_bytes)
      interpreter = put_in(interpreter.memory, memory)

      assert {:error, :unknown_instruction} == Interpreter.cycle(interpreter)
    end
  end

  describe "pixelmap/1" do
    test "should return a list with the pixel content of the interpreter's display" do
      interpreter = Interpreter.new()

      pixelmap = Interpreter.pixelmap(interpreter)

      flat_pixelmap = List.flatten(pixelmap)

      assert Enum.all?(pixelmap, &is_list/1)
      assert Enum.count(flat_pixelmap) == 2048
      assert Enum.all?(flat_pixelmap, &(&1 == 0))
    end
  end
end
