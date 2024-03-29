defmodule Chip8.InterpreterTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Font
  alias Chip8.Interpreter.Instruction
  alias Chip8.Interpreter.Keyboard
  alias Chip8.Interpreter.Memory
  alias Chip8.Interpreter.Timer
  alias Chip8.Interpreter.VRegisters
  alias Chip8.Stack

  @instruction_size Instruction.byte_size()

  describe "initialize/1" do
    @program <<0x6A, 0x95, 0x27, 0x76, 0x38, 0x78, 0x25, 0x82>>

    test "should return an interpreter struct" do
      interpreter = Interpreter.initialize(@program)

      assert %Interpreter{} = interpreter
    end

    test "should return an interpreter with all components properly intialized" do
      interpreter = Interpreter.initialize(@program)

      assert %Display{} = interpreter.display
      assert %Memory{} = interpreter.memory
      assert interpreter.cycle_rate == 10
      assert interpreter.dt == Timer.new()
      assert interpreter.keyboard == Keyboard.new()
      assert interpreter.pc == 0x200
      assert interpreter.st == Timer.new()
      assert interpreter.stack == Stack.new()
      assert interpreter.v == VRegisters.new()
    end

    test "should return an interpreter with font data loaded on memory" do
      interpreter = Interpreter.initialize(@program)

      font_address = 0x050
      font_data = Font.data()
      font_size = Enum.count(font_data)

      assert Memory.read(interpreter.memory, font_address, font_size) == font_data
    end

    test "should return an interpreter struct with program data loaded on memory" do
      interpreter = Interpreter.initialize(@program)

      program_size = byte_size(@program)
      program_data = :binary.bin_to_list(@program)

      assert Memory.read(interpreter.memory, 0x200, program_size) == program_data
    end

    test "should return an interpreter struct with the given cycle rate" do
      cycle_rate = :rand.uniform(100)
      interpreter = Interpreter.initialize(@program, cycle_rate: cycle_rate)

      assert interpreter.cycle_rate == cycle_rate
    end
  end

  describe "new/0" do
    test "should return an interpreter struct" do
      interpreter = Interpreter.new()

      assert %Interpreter{} = interpreter
    end

    test "should return an interpreter with all components properly intialized" do
      interpreter = Interpreter.new()

      assert %Display{} = interpreter.display
      assert %Memory{} = interpreter.memory
      assert interpreter.cycle_rate == 10
      assert interpreter.dt == Timer.new()
      assert interpreter.keyboard == Keyboard.new()
      assert interpreter.pc == 0x200
      assert interpreter.st == Timer.new()
      assert interpreter.stack == Stack.new()
      assert interpreter.v == VRegisters.new()
    end

    test "should return an interpreter with the given cycle rate" do
      cycle_rate = :rand.uniform(100)
      interpreter = Interpreter.new(cycle_rate: cycle_rate)

      assert interpreter.cycle_rate == cycle_rate
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
      program = <<0x6A, 0x95, 0x27, 0x76, 0x38, 0x78, 0x25, 0x82>>

      loaded_interpreter = Interpreter.load_program(interpreter, program)
      program_data = :binary.bin_to_list(program)

      assert %Interpreter{} = loaded_interpreter
      assert Memory.read(loaded_interpreter.memory, 0x200, 8) == program_data
    end
  end

  describe "cycle/1" do
    test "should return an interpreter struct after executing the cycle rate amount of instructions" do
      interpreter = Interpreter.new()
      jp_bytes = [0x12, 0x04, 0x00, 0x00, 0x12, 0x00]
      memory = Memory.write(interpreter.memory, interpreter.pc, jp_bytes)
      interpreter = put_in(interpreter.memory, memory)

      assert {:ok, cycled_interpreter = %Interpreter{}} = Interpreter.cycle(interpreter)

      assert cycled_interpreter.pc == 0x200
    end

    test "should return an error when an instruction is invalid" do
      interpreter = Interpreter.new()
      invalid_bytes = [0xFF, 0xFF]
      memory = Memory.write(interpreter.memory, interpreter.pc, invalid_bytes)
      interpreter = put_in(interpreter.memory, memory)

      assert {:error, :unknown_instruction} == Interpreter.cycle(interpreter)
    end

    test "should not execute the remaining instructions when an instruction at the middle is invalid" do
      interpreter = Interpreter.new()
      invalid_bytes = [0x12, 0x04, 0x00, 0x00, 0xFF, 0xFF, 0x60, 0x29]
      memory = Memory.write(interpreter.memory, interpreter.pc, invalid_bytes)
      interpreter = put_in(interpreter.memory, memory)

      assert {:error, :unknown_instruction} == Interpreter.cycle(interpreter)
    end
  end

  describe "tick_timers/1" do
    test "should return an interpreter with dt decremented by 1" do
      interpreter = Interpreter.new()
      dt_value = :rand.uniform(0xFFFF) + 1
      dt = Timer.new(dt_value)
      interpreter = put_in(interpreter.dt, dt)

      assert ticked_interpreter = Interpreter.tick_timers(interpreter)

      assert %Interpreter{} = ticked_interpreter
      assert ticked_interpreter.dt == Timer.new(dt_value - 1)
    end

    test "should return an interpreter with st decremented by 1" do
      interpreter = Interpreter.new()
      st_value = :rand.uniform(0xFFFF) + 1
      st = Timer.new(st_value)
      interpreter = put_in(interpreter.st, st)

      assert ticked_interpreter = Interpreter.tick_timers(interpreter)

      assert %Interpreter{} = ticked_interpreter
      assert ticked_interpreter.st == Timer.new(st_value - 1)
    end

    test "should return an interpreter with dt unchanged when is equals to 0" do
      interpreter = Interpreter.new()

      assert ticked_interpreter = Interpreter.tick_timers(interpreter)

      assert ticked_interpreter.dt == interpreter.dt
    end

    test "should return an interpreter with st unchanged when is equals to 0" do
      interpreter = Interpreter.new()

      assert ticked_interpreter = Interpreter.tick_timers(interpreter)

      assert ticked_interpreter.st == interpreter.st
    end

    test "should return an interpreter with dt reseted when is less than 0" do
      interpreter = Interpreter.new()
      dt = Timer.new(-1)
      interpreter = put_in(interpreter.dt, dt)

      assert ticked_interpreter = Interpreter.tick_timers(interpreter)

      assert ticked_interpreter.dt == Timer.new()
    end

    test "should return an interpreter with st reseted when is less than 0" do
      interpreter = Interpreter.new()
      st = Timer.new(-1)
      interpreter = put_in(interpreter.st, st)

      assert ticked_interpreter = Interpreter.tick_timers(interpreter)

      assert ticked_interpreter.st == Timer.new()
    end
  end

  describe "press_key/2" do
    test "should return an interpreter with the given keyboard key as pressed" do
      interpreter = Interpreter.new()
      key = :rand.uniform(0xF)

      interpreter_with_key_pressed = Interpreter.press_key(interpreter, key)

      assert Keyboard.is_pressed?(interpreter_with_key_pressed.keyboard, key)
    end

    test "should return an interpreter unchanged when the given keyboard key is already pressed" do
      interpreter = Interpreter.new()
      key = :rand.uniform(0xF)
      keyboard = Keyboard.press_key(interpreter.keyboard, key)
      interpreter = put_in(interpreter.keyboard, keyboard)

      interpreter_with_key_pressed = Interpreter.press_key(interpreter, key)

      assert interpreter_with_key_pressed == interpreter
    end
  end

  describe "release_key/2" do
    test "should return an interpreter with the given keyboard key as not pressed" do
      interpreter = Interpreter.new()
      key = :rand.uniform(0xF)
      keyboard = Keyboard.press_key(interpreter.keyboard, key)
      interpreter = put_in(interpreter.keyboard, keyboard)

      interpreter_with_key_released = Interpreter.release_key(interpreter, key)

      refute Keyboard.is_pressed?(interpreter_with_key_released.keyboard, key)
    end

    test "should return an interpreter unchanged when the given keyboard key is already pressed" do
      interpreter = Interpreter.new()
      key = :rand.uniform(0xF)

      interpreter_with_key_released = Interpreter.release_key(interpreter, key)

      refute Keyboard.is_pressed?(interpreter_with_key_released.keyboard, key)
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

  describe "change_cycle_rate/2" do
    test "should return an interpreter set with the given cycle rate" do
      interpreter = Interpreter.new()

      changed_interpreter = Interpreter.change_cycle_rate(interpreter, 1)

      assert changed_interpreter.cycle_rate == 1
    end
  end

  describe "is_timer_active?/2" do
    test "should return true when the display timer has a value greater than 0" do
      value = :rand.uniform(0xFFFF) + 1
      interpreter = Interpreter.new()
      interpreter = put_in(interpreter.dt, Timer.new(value))

      assert Interpreter.is_timer_active?(interpreter, :dt)
    end

    test "should return true when the display timer has a value equals to 0" do
      interpreter = Interpreter.new()
      interpreter = put_in(interpreter.dt, Timer.new(0))

      refute Interpreter.is_timer_active?(interpreter, :dt)
    end

    test "should return true when the sound timer has a value greater than 0" do
      value = :rand.uniform(0xFFFF) + 1
      interpreter = Interpreter.new()
      interpreter = put_in(interpreter.st, Timer.new(value))

      assert Interpreter.is_timer_active?(interpreter, :st)
    end

    test "should return true when the sound timer has a value equals to 0" do
      interpreter = Interpreter.new()
      interpreter = put_in(interpreter.st, Timer.new(0))

      refute Interpreter.is_timer_active?(interpreter, :st)
    end
  end

  describe "display_diff/2" do
    test "should return a list with coordinates and the state of all pixels on the second interpreter's display that has a different state from their equivalent ones on the first interpreter's display" do
      interpreter = Interpreter.new()

      display = Display.new(8, 8)
      sprite = Display.Sprite.new([0x05, 0x05])
      coordinates = Display.Coordinates.new(0, 0)
      {drawed_display, _} = Display.draw(display, coordinates, sprite)

      drawed_interpreter = put_in(interpreter.display, drawed_display)

      pixels_diff = Interpreter.display_changes(interpreter, drawed_interpreter)
      assert Enum.sort(pixels_diff) == [{{5, 0}, 1}, {{5, 1}, 1}, {{7, 0}, 1}, {{7, 1}, 1}]
    end

    test "should return an empty list when there is no difference between the pixel's state between the first interpreter's display and the second interpreter's display" do
      interpreter = Interpreter.new()

      assert Interpreter.display_changes(interpreter, interpreter) == []
    end
  end

  describe "info/0" do
    test "should return a map with general information about an interpreter" do
      assert Interpreter.info() == %{
               display: %{
                 height: 32,
                 width: 64
               },
               keyboard: %{
                 keys: Keyboard.keys()
               }
             }
    end
  end
end
