defmodule Chip8.MemoryTest do
  use ExUnit.Case, async: true

  alias Chip8.Memory

  describe "new/1" do
    test "should return a memory struct" do
      memory = Memory.new(10)

      assert %Memory{} = memory
    end

    test "should return a memory with the given size" do
      size = :rand.uniform(100)
      memory = Memory.new(size)

      assert size == memory.size
    end
  end
end
