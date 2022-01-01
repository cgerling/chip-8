defmodule Chip8.InstructionTest do
  use ExUnit.Case, async: true

  alias Chip8.Fixture.ArgumentsInstruction
  alias Chip8.Fixture.IdentityInstruction
  alias Chip8.Instruction
  alias Chip8.Runtime

  describe "new/1" do
    test "should return a instruction struct for the given module" do
      instruction = Instruction.new(IdentityInstruction)

      assert %Instruction{} = instruction
      assert IdentityInstruction == instruction.module
      assert %{} == instruction.arguments
    end
  end

  describe "new/2" do
    test "should return a instruction struct for the given module with the given arguments" do
      instruction = Instruction.new(ArgumentsInstruction, %{foo: :bar})

      assert %Instruction{} = instruction
      assert ArgumentsInstruction == instruction.module
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
    test "should return a runtime struct updated by the given instruction" do
      runtime = Runtime.new()

      pc_value = :rand.uniform(0xFFFF)
      instruction = Instruction.new(ArgumentsInstruction, %{value: pc_value})

      executed_runtime = Instruction.execute(instruction, runtime)

      assert %Runtime{} = executed_runtime
      assert pc_value == executed_runtime.pc
    end
  end

  describe "byte_size/0" do
    test "should return the byte size of an instruction" do
      byte_size = Instruction.byte_size()

      assert 2 == byte_size
    end
  end
end
