defmodule Chip8.Interpreter.Instruction.DRWTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Display
  alias Chip8.Interpreter.Display.Coordinates
  alias Chip8.Interpreter.Instruction.Argument.Nibble
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.DRW
  alias Chip8.Interpreter.Memory

  describe "execute/2" do
    test "should return an interpreter with sprite at address I rendered in the display" do
      interpreter = Interpreter.new()
      i = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.i, i)
      memory = Memory.write(interpreter.memory, i, [0xD9])
      interpreter = put_in(interpreter.memory, memory)

      vx = %Register{value: 0}
      vy = %Register{value: 0}
      nibble = %Nibble{value: 0x1}
      arguments = {vx, vy, nibble}
      executed_interpreter = DRW.execute(interpreter, arguments)

      sprite_rendered_pixels =
        executed_interpreter.display |> Display.pixelmap() |> List.first() |> Enum.slice(0, 8)

      assert %Interpreter{} = executed_interpreter
      assert sprite_rendered_pixels == [1, 1, 0, 1, 1, 0, 0, 1]
    end

    test "should return an interpreter with VF set to 0 when there was no pixel collision" do
      interpreter = Interpreter.new()

      vx = %Register{value: :rand.uniform(0xF)}
      vy = %Register{value: :rand.uniform(0xF)}
      nibble = %Nibble{value: :rand.uniform(0xF)}
      arguments = {vx, vy, nibble}
      executed_interpreter = DRW.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 0 == executed_interpreter.v[0xF]
    end

    test "should return an interpreter with VF set to 1 when there was a pixel collision" do
      interpreter = Interpreter.new()
      i = :rand.uniform(0xFFF)
      interpreter = put_in(interpreter.i, i)
      sprite_data = [0x1]
      memory = Memory.write(interpreter.memory, i, sprite_data)
      interpreter = put_in(interpreter.memory, memory)
      sprite = Display.create_sprite(sprite_data)
      coordinates = Coordinates.new(0, 0)
      display = Display.draw(interpreter.display, coordinates, sprite)
      interpreter = put_in(interpreter.display, display)

      vx = %Register{value: 0}
      vy = %Register{value: 0}
      nibble = %Nibble{value: 0x1}
      arguments = {vx, vy, nibble}
      executed_interpreter = DRW.execute(interpreter, arguments)

      assert %Interpreter{} = executed_interpreter
      assert 1 == executed_interpreter.v[0xF]
    end
  end
end
