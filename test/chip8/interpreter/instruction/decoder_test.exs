defmodule Chip8.Interpreter.Instruction.DecoderTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Instruction
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Nibble
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.Decoder

  describe "decode/1" do
    test "should return a instruction struct when the given bytes match the `CLS` instruction" do
      bytes = build_instruction_bytes(0x00E0)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.CLS == instruction.module
      assert {} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `RET` instruction" do
      bytes = build_instruction_bytes(0x00EE)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.RET == instruction.module
      assert {} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SYS address` instruction" do
      bytes = build_instruction_bytes(0x0A4F)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SYS == instruction.module
      assert {Address.new(0xA4F)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `JP address` instruction" do
      bytes = build_instruction_bytes(0x14ED)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.JP == instruction.module
      assert {Address.new(0x4ED)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `CALL address` instruction" do
      bytes = build_instruction_bytes(0x2B06)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.CALL == instruction.module
      assert {Address.new(0xB06)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SE Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x33A8)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SE == instruction.module
      assert {Register.v(0x3), Byte.new(0xA8)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SNE Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x498F)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SNE == instruction.module
      assert {Register.v(0x9), Byte.new(0x8F)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SE Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x5E00)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SE == instruction.module
      assert {Register.v(0xE), Register.v(0x0)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x6629)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.v(0x6), Byte.new(0x29)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `ADD Vx, byte` instruction" do
      bytes = build_instruction_bytes(0x75DB)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.ADD == instruction.module
      assert {Register.v(0x5), Byte.new(0xDB)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8970)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.v(0x9), Register.v(0x7)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `OR Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8A31)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.OR == instruction.module
      assert {Register.v(0xA), Register.v(0x3)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `AND Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x86D2)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.AND == instruction.module
      assert {Register.v(0x6), Register.v(0xD)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `XOR Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8C03)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.XOR == instruction.module
      assert {Register.v(0xC), Register.v(0x0)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `ADD Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8F74)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.ADD == instruction.module
      assert {Register.v(0xF), Register.v(0x7)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SUB Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x85B5)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SUB == instruction.module
      assert {Register.v(0x5), Register.v(0xB)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SHR Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8C96)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SHR == instruction.module
      assert {Register.v(0xC), Register.v(0x9)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SUBN Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8307)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SUBN == instruction.module
      assert {Register.v(0x3), Register.v(0x0)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SHL Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x8AEE)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SHL == instruction.module
      assert {Register.v(0xA), Register.v(0xE)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SNE Vx, Vy` instruction" do
      bytes = build_instruction_bytes(0x90D0)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SNE == instruction.module
      assert {Register.v(0x0), Register.v(0xD)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD I, address` instruction" do
      bytes = build_instruction_bytes(0xA3FF)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.i(), Address.new(0x3FF)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `JP V0, address` instruction" do
      bytes = build_instruction_bytes(0xB47B)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.JP == instruction.module
      assert {Register.v(0x0), Address.new(0x47B)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `RND Vx, byte` instruction" do
      bytes = build_instruction_bytes(0xC86A)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.RND == instruction.module
      assert {Register.v(0x8), Byte.new(0x6A)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `DRW Vx, Vy, nibble` instruction" do
      bytes = build_instruction_bytes(0xD7F2)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.DRW == instruction.module
      assert {Register.v(0x7), Register.v(0xF), Nibble.new(0x2)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SKP Vx` instruction" do
      bytes = build_instruction_bytes(0xEC9E)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SKP == instruction.module
      assert {Register.v(0xC)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `SKNP Vx` instruction" do
      bytes = build_instruction_bytes(0xEDA1)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.SKNP == instruction.module
      assert {Register.v(0xD)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD Vx, DT` instruction" do
      bytes = build_instruction_bytes(0xFA07)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.v(0xA), Register.dt()} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD Vx, K` instruction" do
      bytes = build_instruction_bytes(0xF50A)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.v(0x5), Register.keyboard()} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD DT, Vy` instruction" do
      bytes = build_instruction_bytes(0xF315)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.dt(), Register.v(0x3)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD ST, Vy` instruction" do
      bytes = build_instruction_bytes(0xFF18)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.st(), Register.v(0xF)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `ADD I, Vx` instruction" do
      bytes = build_instruction_bytes(0xF21E)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.ADD == instruction.module
      assert {Register.i(), Register.v(0x2)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD F, Vx` instruction" do
      bytes = build_instruction_bytes(0xF629)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.font(), Register.v(0x6)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD B, Vy` instruction" do
      bytes = build_instruction_bytes(0xF433)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.bcd(), Register.v(0x4)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD I, Vy` instruction" do
      bytes = build_instruction_bytes(0xFD55)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.memory(), Register.v(0xD)} == instruction.arguments
    end

    test "should return a instruction struct when the given bytes match the `LD Vx, I` instruction" do
      bytes = build_instruction_bytes(0xFF65)

      assert {:ok, instruction = %Instruction{}} = Decoder.decode(bytes)

      assert Instruction.LD == instruction.module
      assert {Register.v(0xF), Register.memory()} == instruction.arguments
    end

    test "should return an unknown instruction error when the given bytes are not compatible with any existing instruction" do
      bytes = build_instruction_bytes(0xFFFF)

      assert {:error, :unknown_instruction} = Decoder.decode(bytes)
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
