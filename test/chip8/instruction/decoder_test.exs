defmodule Chip8.Instruction.DecoderTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction
  alias Chip8.Instruction.Decoder

  describe "decode/1" do
    test "should return a instruction struct for SYS address bytes" do
      bytes = [0x0A, 0x4F]

      instruction = Decoder.decode(bytes)

      assert %Instruction{} = instruction
      assert Chip8.Instruction.SYS == instruction.module
      assert %{address: 0xA4F} == instruction.arguments
    end
  end
end
