defmodule Chip8.Instruction.DecoderTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction
  alias Chip8.Instruction.Decoder

  describe "decode/1" do
    test "should return a instruction struct for `CLS` instruction" do
      bytes = [0x00, 0xE0]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Chip8.Instruction.CLS == instruction.module
      assert %{} == instruction.arguments
    end

    test "should return a instruction struct for `RET` instruction" do
      bytes = [0x00, 0xEE]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Chip8.Instruction.RET == instruction.module
      assert %{} == instruction.arguments
    end

    test "should return a instruction struct for `SYS address` instruction" do
      bytes = [0x0A, 0x4F]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Chip8.Instruction.SYS == instruction.module
      assert %{address: 0xA4F} == instruction.arguments
    end

    test "should return a instruction struct for `CALL address` instruction" do
      bytes = [0x2B, 0x06]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.CALL == instruction.module
      assert %{address: 0xB06} == instruction.arguments
    end

    test "should return a instruction struct for `SE Vx, byte` instruction" do
      bytes = [0x33, 0xA8]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SE == instruction.module
      assert %{x: 0x3, byte: 0xA8} == instruction.arguments
    end

    test "should return a instruction struct for `SNE Vx, byte` instruction" do
      bytes = [0x49, 0x8F]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SNE == instruction.module
      assert %{x: 0x9, byte: 0x8F} == instruction.arguments
    end

    test "should return a instruction struct for the `SE Vx, Vy` instruction" do
      bytes = [0x5E, 0x00]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SE == instruction.module
      assert %{x: 0xE, y: 0x0} == instruction.arguments
    end

    test "should return a instruction struct for the `OR Vx, Vy` instruction" do
      bytes = [0x8A, 0x31]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.OR == instruction.module
      assert %{x: 0xA, y: 0x3} == instruction.arguments
    end

    test "should return a instruction struct for the `AND Vx, Vy` instruction" do
      bytes = [0x86, 0xD2]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.AND == instruction.module
      assert %{x: 0x6, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `SNE Vx, Vy` instruction" do
      bytes = [0x90, 0xD0]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SNE == instruction.module
      assert %{x: 0x0, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `DRW Vx, Vy, nibble` instruction" do
      bytes = [0xD7, 0xF2]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Chip8.Instruction.DRW == instruction.module
      assert %{x: 0x7, y: 0xF, nibble: 0x2} == instruction.arguments
    end
  end
end
