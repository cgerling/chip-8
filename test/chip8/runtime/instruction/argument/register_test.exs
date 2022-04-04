defmodule Chip8.Runtime.Instruction.Argument.RegisterTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime.Instruction.Argument.Register

  describe "v/1" do
    test "should return a Register struct with value as the given index" do
      index = :rand.uniform(0xF)

      register = Register.v(index)

      assert %Register{} = register
      assert register.value == index
    end
  end

  describe "bcd/0" do
    test "should return a Register struct with value as bcd" do
      register = Register.bcd()

      assert %Register{} = register
      assert register.value == :bcd
    end
  end

  describe "dt/0" do
    test "should return a Register struct with value as dt" do
      register = Register.dt()

      assert %Register{} = register
      assert register.value == :dt
    end
  end

  describe "font/0" do
    test "should return a Register struct with value as font" do
      register = Register.font()

      assert %Register{} = register
      assert register.value == :font
    end
  end

  describe "i/0" do
    test "should return a Register struct with value as i" do
      register = Register.i()

      assert %Register{} = register
      assert register.value == :i
    end
  end

  describe "keyboard/0" do
    test "should return a Register struct with value as keyboard" do
      register = Register.keyboard()

      assert %Register{} = register
      assert register.value == :keyboard
    end
  end

  describe "memory/0" do
    test "should return a Register struct with value as memory" do
      register = Register.memory()

      assert %Register{} = register
      assert register.value == :memory
    end
  end

  describe "st/0" do
    test "should return a Register struct with value as st" do
      register = Register.st()

      assert %Register{} = register
      assert register.value == :st
    end
  end
end
