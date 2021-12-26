defmodule Chip8.VRegistersTest do
  use ExUnit.Case, async: true

  alias Chip8.VRegisters

  describe "new/0" do
    test "should return a v registers struct" do
      v_registers = VRegisters.new()

      assert %VRegisters{} = v_registers
    end
  end
end
