defmodule Chip8.Runtime.Instruction.SKNPTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.SKNP
  alias Chip8.Runtime.VRegisters

  describe "execute/2" do
    test "should return a runtime with pc set to next instruction when key of vx is not pressed" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xF)
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)

      vx = %Register{value: x}
      arguments = {vx}
      executed_runtime = SKNP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc + 2 == executed_runtime.pc
    end

    test "should return a runtime with pc unchanged when key of vx is pressed" do
      runtime = Runtime.new()
      x = :rand.uniform(0xF)
      x_value = :rand.uniform(0xF)
      v_registers = VRegisters.set(runtime.v, x, x_value)
      runtime = put_in(runtime.v, v_registers)
      runtime = put_in(runtime.keyboard.keys[x_value], :pressed)

      vx = %Register{value: x}
      arguments = {vx}
      executed_runtime = SKNP.execute(runtime, arguments)

      assert %Runtime{} = executed_runtime
      assert runtime.pc == executed_runtime.pc
    end
  end
end