defmodule Chip8.InstructionTest do
  use ExUnit.Case, async: true

  alias Chip8.Fixture.ArgumentsInstruction
  alias Chip8.Fixture.IdentityInstruction
  alias Chip8.Instruction
  alias Chip8.Runtime

  describe "new/1" do
    test "should return a instruction struct" do
      instruction = Instruction.new(IdentityInstruction)

      assert %Instruction{} = instruction
    end

    test "should return a instruction of the given module" do
      instruction = Instruction.new(IdentityInstruction)

      assert IdentityInstruction == instruction.module
    end

    test "should return a instruction with empty arguments" do
      instruction = Instruction.new(IdentityInstruction)

      assert %{} == instruction.arguments
    end
  end

  describe "new/2" do
    test "should return a instruction struct" do
      instruction = Instruction.new(ArgumentsInstruction, %{foo: :bar})

      assert %Instruction{} = instruction
    end

    test "should return a instruction of the given module" do
      instruction = Instruction.new(ArgumentsInstruction, %{foo: :bar})

      assert ArgumentsInstruction == instruction.module
    end

    test "should return a instruction with the given arguments" do
      instruction = Instruction.new(ArgumentsInstruction, %{foo: :bar})

      assert %{foo: :bar} == instruction.arguments
    end
  end

  describe "decode/1" do
    test "should return a instruction struct" do
      bytes = [0x00, 0x0F]

      instruction = Instruction.decode(bytes)

      assert %Instruction{} = instruction
      assert is_atom(instruction.module)
      assert is_map(instruction.arguments)
    end
  end

  describe "execute/2" do
    test "should return a runtime struct" do
      runtime = Runtime.new()

      instruction = Instruction.new(IdentityInstruction)

      executed_runtime = Instruction.execute(instruction, runtime)

      assert %Runtime{} = executed_runtime
    end

    test "should return a runtime state updated by the given instruction" do
      runtime = Runtime.new()

      pc_value = :rand.uniform(0xFFFF)
      instruction = Instruction.new(ArgumentsInstruction, %{value: pc_value})

      executed_runtime = Instruction.execute(instruction, runtime)

      assert pc_value == executed_runtime.pc
    end
  end
end
