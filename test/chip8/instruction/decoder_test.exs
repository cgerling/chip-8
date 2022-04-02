defmodule Chip8.Instruction.DecoderTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction
  alias Chip8.Instruction.Argument.Address
  alias Chip8.Instruction.Decoder

  describe "decode/1" do
    test "should return a instruction struct for `CLS` instruction" do
      bytes = build_instruction_bytes(0x00E0)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.CLS == instruction.module
      assert {} == instruction.arguments
    end

    test "should return a instruction struct for `RET` instruction" do
      bytes = build_instruction_bytes(0x00EE)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.RET == instruction.module
      assert {} == instruction.arguments
    end

    test "should return a instruction struct for `SYS address` instruction" do
      bytes = build_instruction_bytes(0x0A4F)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SYS == instruction.module
      assert {Address.new(0xA4F)} == instruction.arguments
    end

    test "should return a instruction struct for `JP address` instruction" do
      bytes = build_instruction_bytes(0x14ED)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.JP == instruction.module
      assert %{address: 0x4ED} == instruction.arguments
    end

    test "should return a instruction struct for `CALL address` instruction" do
      bytes = build_instruction_bytes(0x2B06)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.CALL == instruction.module
      assert %{address: 0xB06} == instruction.arguments
    end

    test "should return a instruction struct for `SE Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x33A8)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SE == instruction.module
      assert %{x: 0x3, byte: 0xA8} == instruction.arguments
    end

    test "should return a instruction struct for `SNE Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x498F)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SNE == instruction.module
      assert %{x: 0x9, byte: 0x8F} == instruction.arguments
    end

    test "should return a instruction struct for the `SE Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x5E00)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SE == instruction.module
      assert %{x: 0xE, y: 0x0} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x6629)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: 0x6, byte: 0x29} == instruction.arguments
    end

    test "should return a instruction struct for the `ADD Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x75DB)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.ADD == instruction.module
      assert %{x: 0x5, byte: 0xDB} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8970)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: 0x9, y: 0x7} == instruction.arguments
    end

    test "should return a instruction struct for the `OR Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8A31)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.OR == instruction.module
      assert %{x: 0xA, y: 0x3} == instruction.arguments
    end

    test "should return a instruction struct for the `AND Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x86D2)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.AND == instruction.module
      assert %{x: 0x6, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `XOR Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8C03)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.XOR == instruction.module
      assert %{x: 0xC, y: 0x0} == instruction.arguments
    end

    test "should return a instruction struct for the `ADD Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8F74)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.ADD == instruction.module
      assert %{x: 0xF, y: 0x7} == instruction.arguments
    end

    test "should return a instruction struct for the `SUB Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x85B5)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SUB == instruction.module
      assert %{x: 0x5, y: 0xB} == instruction.arguments
    end

    test "should return a instruction struct for the `SHR Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8C96)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SHR == instruction.module
      assert %{x: 0xC, y: 0x9} == instruction.arguments
    end

    test "should return a instruction struct for the `SUBN Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8307)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SUBN == instruction.module
      assert %{x: 0x3, y: 0x0} == instruction.arguments
    end

    test "should return a instruction struct for the `SHL Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8AEE)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SHL == instruction.module
      assert %{x: 0xA, y: 0xE} == instruction.arguments
    end

    test "should return a instruction struct for the `SNE Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x90D0)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SNE == instruction.module
      assert %{x: 0x0, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `LD I, address` instructino" do
      bytes = build_instruction_bytes(0xA3FF)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Instruction.LD == instruction.module
      assert %{address: 0x3FF} == instruction.arguments
    end

    test "should return a instruction struct for the `JP V0, address` instruction" do
      bytes = build_instruction_bytes(0xB47B)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.JP == instruction.module
      assert %{x: 0x0, address: 0x47B} == instruction.arguments
    end

    test "should return a instruction struct for the `RND Vx, byte` instruction" do
      bytes = build_instruction_bytes(0xC86A)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.RND == instruction.module
      assert %{x: 0x8, byte: 0x6A} == instruction.arguments
    end

    test "should return a instruction struct for the `DRW Vx, Vy, nibble` instruction" do
      bytes = build_instruction_bytes(0xD7F2)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.DRW == instruction.module
      assert %{x: 0x7, y: 0xF, nibble: 0x2} == instruction.arguments
    end

    test "should return a instruction struct for the `SKP Vx` instruction" do
      bytes = build_instruction_bytes(0xEC9E)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SKP == instruction.module
      assert %{x: 0xC} == instruction.arguments
    end

    test "should return a instruction struct for the `SKNP Vx` instruction" do
      bytes = build_instruction_bytes(0xEDA1)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.SKNP == instruction.module
      assert %{x: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, DT` instruction" do
      bytes = build_instruction_bytes(0xFA07)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: 0xA, y: :dt} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, K` instruction" do
      bytes = build_instruction_bytes(0xF50A)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: 0x5, y: :keyboard} == instruction.arguments
    end

    test "should return a instruction struct for the `LD DT, Vy` instruction" do
      bytes = build_instruction_bytes(0xF315)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: :dt, y: 0x3} == instruction.arguments
    end

    test "should return a instruction struct for the `LD ST, Vy` instruction" do
      bytes = build_instruction_bytes(0xFF18)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: :st, y: 0xF} == instruction.arguments
    end

    test "should return a instruction struct for the `ADD I, Vx` instruction" do
      bytes = build_instruction_bytes(0xF21E)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.ADD == instruction.module
      assert %{x: :i, y: 0x2} == instruction.arguments
    end

    test "should return a instruction struct for the `LD F, Vx` instruction" do
      bytes = build_instruction_bytes(0xF629)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: :font, y: 0x6} == instruction.arguments
    end

    test "should return a instruction struct for the `LD B, Vy` instruction" do
      bytes = build_instruction_bytes(0xF433)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: :bcd, y: 0x4} == instruction.arguments
    end

    test "should return a instruction struct for the `LD I, Vy` instruction" do
      bytes = build_instruction_bytes(0xFD55)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
      assert %{x: :memory, y: 0xD} == instruction.arguments
    end

    test "should return a instruction struct for the `LD Vx, I` instruction" do
      bytes = build_instruction_bytes(0xFF65)

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction

      assert Instruction.LD == instruction.module
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
