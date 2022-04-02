defmodule Chip8.InstructionTest do
  use ExUnit.Case, async: true

  alias Chip8.Instruction
  alias Chip8.Instruction.Argument.Address
  alias Chip8.Runtime

  defmodule IdentityInstruction do
    use Chip8.Instruction

    alias Chip8.Runtime

    @impl Chip8.Instruction
    def execute(%Runtime{} = runtime, arguments) when is_tuple(arguments) do
      runtime
    end
  end

  defmodule SetPCInstruction do
    use Chip8.Instruction

    alias Chip8.Instruction.Argument.Address
    alias Chip8.Runtime

    @impl Chip8.Instruction
    def execute(%Runtime{} = runtime, {%Address{} = address}) do
      %{runtime | pc: address.value}
    end
  end

  describe "new/1" do
    test "should return a instruction struct of the given module with the given arguments" do
      instruction = IdentityInstruction.new(%{})

      assert %Instruction{} = instruction
      assert IdentityInstruction == instruction.module
      assert %{} == instruction.arguments
    end

    test "should return a instruction struct of the given module with the given arguments when arguments is a tuple" do
      instruction = IdentityInstruction.new({})

      assert %Instruction{} = instruction
      assert IdentityInstruction == instruction.module
      assert {} == instruction.arguments
    end
  end

  describe "new/2" do
    test "should return a instruction struct for the given module with the given arguments" do
      instruction = Instruction.new(IdentityInstruction, {Address.new(0)})

      assert %Instruction{} = instruction
      assert IdentityInstruction == instruction.module
      assert {Address.new(0)} == instruction.arguments
    end
  end

  describe "decode/1" do
    test "should return a instruction struct" do
      bytes = [0x00, 0x0F]

      instruction = Instruction.decode(bytes)

      assert %Instruction{} = instruction
      assert is_atom(instruction.module)
      assert is_tuple(instruction.arguments)
    end
  end

  describe "execute/2" do
    test "should return a runtime struct updated by the given instruction" do
      runtime = Runtime.new()

      pc_value = :rand.uniform(0xFFFF)
      instruction = Instruction.new(SetPCInstruction, {%Address{value: pc_value}})

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
