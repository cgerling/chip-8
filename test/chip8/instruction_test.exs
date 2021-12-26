defmodule Chip8.InstructionTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction

  describe "new/1" do
    test "should return a instruction struct" do
      instruction = Instruction.new(Instruction.RUN)

      assert %Instruction{} = instruction
    end

    test "should return a instruction of the given module" do
      instruction = Instruction.new(Instruction.RUN)

      assert Instruction.RUN == instruction.module
    end

    test "should return a instruction with empty arguments" do
      instruction = Instruction.new(Instruction.RUN)

      assert %{} == instruction.arguments
    end
  end

  describe "new/2" do
    test "should return a instruction struct" do
      instruction = Instruction.new(Instruction.RUN, %{foo: :bar})

      assert %Instruction{} = instruction
    end

    test "should return a instruction of the given module" do
      instruction = Instruction.new(Instruction.RUN, %{foo: :bar})

      assert Instruction.RUN == instruction.module
    end

    test "should return a instruction with the given arguments" do
      instruction = Instruction.new(Instruction.RUN, %{foo: :bar})

      assert %{foo: :bar} == instruction.arguments
    end
  end
end
