defmodule Chip8.Interpreter.InstructionTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction
  alias Chip8.Interpreter.Instruction.Argument.Address

  defmodule IdentityInstruction do
    use Chip8.Interpreter.Instruction

    alias Chip8.Interpreter

    @impl Chip8.Interpreter.Instruction
    def execute(%Interpreter{} = interpreter, arguments) when is_tuple(arguments) do
      interpreter
    end
  end

  defmodule SetPCInstruction do
    use Chip8.Interpreter.Instruction

    alias Chip8.Interpreter
    alias Chip8.Interpreter.Instruction.Argument.Address

    @impl Chip8.Interpreter.Instruction
    def execute(%Interpreter{} = interpreter, {%Address{} = address}) do
      %{interpreter | pc: address.value}
    end
  end

  describe "new/1" do
    test "should return a instruction struct of the given module with the given arguments" do
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

      assert {:ok, instruction = %Instruction{}} = Instruction.decode(bytes)

      assert is_atom(instruction.module)
      assert is_tuple(instruction.arguments)
    end

    test "should return an unknown instruction when the given bytes do not match any instruction" do
      bytes = [0xFF, 0xFF]

      assert {:error, :unknown_instruction} = Instruction.decode(bytes)
    end
  end

  describe "execute/2" do
    test "should return an interpreter struct updated by the given instruction" do
      interpreter = Interpreter.new()

      pc_value = :rand.uniform(0xFFFF)
      instruction = Instruction.new(SetPCInstruction, {%Address{value: pc_value}})

      executed_interpreter = Instruction.execute(instruction, interpreter)

      assert %Interpreter{} = executed_interpreter
      assert pc_value == executed_interpreter.pc
    end
  end

  describe "byte_size/0" do
    test "should return the byte size of an instruction" do
      byte_size = Instruction.byte_size()

      assert 2 == byte_size
    end
  end
end
