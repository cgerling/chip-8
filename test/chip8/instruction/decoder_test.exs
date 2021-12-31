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

    test "should return a instruction struct for `JP address` instruction" do
      bytes = [0x14, 0xED]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.JP == instruction.module
      assert %{address: 0x4ED} == instruction.arguments
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

    test "should return a instruction struct for the `LD Vx, byte` instruction" do
      bytes = [0x66, 0x29]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: 0x6, byte: 0x29} == instruction.arguments
    end

    test "should return a instruction struct for the `ADD Vx, byte` instruction" do
      bytes = [0x75, 0xDB]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.ADD == instruction.module
      assert %{x: 0x5, byte: 0xDB} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, Vy` instruction" do
      bytes = [0x89, 0x70]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: 0x9, y: 0x7} == instruction.arguments
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

    test "should return a instruction struct for the `XOR Vx, Vy` instruction" do
      bytes = [0x8C, 0x03]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.XOR == instruction.module
      assert %{x: 0xC, y: 0x0} == instruction.arguments
    end

    test "should return a instruction struct for the `ADD Vx, Vy` instruction" do
      bytes = [0x8F, 0x74]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.ADD == instruction.module
      assert %{x: 0xF, y: 0x7} == instruction.arguments
    end

    test "should return a instruction struct for the `SUB Vx, Vy` instruction" do
      bytes = [0x85, 0xB5]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SUB == instruction.module
      assert %{x: 0x5, y: 0xB} == instruction.arguments
    end

    test "should return a instruction struct for the `SHR Vx, Vy` instruction" do
      bytes = [0x8C, 0x96]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SHR == instruction.module
      assert %{x: 0xC, y: 0x9} == instruction.arguments
    end

    test "should return a instruction struct for the `SUBN Vx, Vy` instruction" do
      bytes = [0x83, 0x07]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SUBN == instruction.module
      assert %{x: 0x3, y: 0x0} == instruction.arguments
    end

    test "should return a instruction struct for the `SHL Vx, Vy` instruction" do
      bytes = [0x8A, 0xEE]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SHL == instruction.module
      assert %{x: 0xA, y: 0xE} == instruction.arguments
    end

    test "should return a instruction struct for the `SNE Vx, Vy` instruction" do
      bytes = [0x90, 0xD0]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SNE == instruction.module
      assert %{x: 0x0, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `LD I, address` instructino" do
      bytes = [0xA3, 0xFF]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Chip8.Instruction.LD == instruction.module
      assert %{address: 0x3FF} == instruction.arguments
    end

    test "should return a instruction struct for the `JP V0, address` instruction" do
      bytes = [0xB4, 0x7B]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.JP == instruction.module
      assert %{x: 0x0, address: 0x47B} == instruction.arguments
    end

    test "should return a instruction struct for the `RND Vx, byte` instruction" do
      bytes = [0xC8, 0x6A]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.RND == instruction.module
      assert %{x: 0x8, byte: 0x6A} == instruction.arguments
    end

    test "should return a instruction struct for the `DRW Vx, Vy, nibble` instruction" do
      bytes = [0xD7, 0xF2]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.DRW == instruction.module
      assert %{x: 0x7, y: 0xF, nibble: 0x2} == instruction.arguments
    end

    test "should return a instruction struct for the `SKP Vx` instruction" do
      bytes = [0xEC, 0x9E]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SKP == instruction.module
      assert %{x: 0xC} == instruction.arguments
    end

    test "should return a instruction struct for the `SKNP Vx` instruction" do
      bytes = [0xED, 0xA1]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.SKNP == instruction.module
      assert %{x: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, DT` instruction" do
      bytes = [0xFA, 0x07]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: 0xA, y: :dt} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, K` instruction" do
      bytes = [0xF5, 0x0A]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: 0x5, y: :keyboard} == instruction.arguments
    end

    test "should return a instruction struct for the `LD DT, Vy` instruction" do
      bytes = [0xF3, 0x15]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: :dt, y: 0x3} == instruction.arguments
    end

    test "should return a instruction struct for the `LD ST, Vy` instruction" do
      bytes = [0xFF, 0x18]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: :st, y: 0xF} == instruction.arguments
    end

    test "should return a instruction struct for the `ADD I, Vx` instruction" do
      bytes = [0xF2, 0x1E]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.ADD == instruction.module
      assert %{x: 0x2} == instruction.arguments
    end

    test "should return a instruction struct for the `LD F, Vx` instruction" do
      bytes = [0xF6, 0x29]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: 0x6} == instruction.arguments
    end

    test "should return a instruction struct for the `LD B, Vy` instruction" do
      bytes = [0xF4, 0x33]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: :bcd, y: 0x4} == instruction.arguments
    end

    test "should return a instruction struct for the `LD I, Vy` instruction" do
      bytes = [0xFD, 0x55]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: :memory, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, I` instruction" do
      bytes = [0xFF, 0x65]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Chip8.Instruction.LD == instruction.module
      assert %{x: 0xF, y: :memory} == instruction.arguments
    end
  end

  defp build_instruction_bytes(instruction) when is_integer(instruction) and instruction > 0 do
    digits = Integer.digits(instruction, 16)

    padding_size = 4 - Enum.count(digits)
    padding = List.duplicate(0, padding_size)

    [padding | digits]
    |> List.flatten()
    |> Enum.chunk_every(2)
    |> Enum.map(&Integer.undigits(&1, 16))
  end
end
