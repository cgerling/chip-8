defmodule Chip8.MemoryTest do
  use ExUnit.Case, async: true

  alias Chip8.Memory

  describe "new/1" do
    test "should return a memory struct with the given size" do
      size = :rand.uniform(100)
      memory = Memory.new(size)

      assert %Memory{} = memory
      assert size == memory.size
    end
  end

  describe "read/3" do
    test "should return a list of memory data with size as the given amount" do
      size = :rand.uniform(100)
      memory = Memory.new(size)

      address_offset = :rand.uniform(size)
      address = size - address_offset
      amount = :rand.uniform(address_offset)

      data = Memory.read(memory, address, amount)

      assert amount == Enum.count(data)
    end

    test "should return a list of memory data with size less than the given amount when overflows memory" do
      size = :rand.uniform(100)
      memory = Memory.new(size)

      amount = :rand.uniform(size)
      actual_amount = trunc(amount / 2)
      address = size - actual_amount

      data = Memory.read(memory, address, amount)

      assert actual_amount == Enum.count(data)
    end

    test "should return an empty list when address is greather than or equal to memory size" do
      size = :rand.uniform(100)
      memory = Memory.new(size)

      address = size + :rand.uniform(size)
      amount = :rand.uniform(10)

      data = Memory.read(memory, address, amount)

      assert [] == data
    end
  end

  describe "write/3" do
    test "should return a memory struct unchanged when the given data is empty" do
      memory = Memory.new(10)

      data = []
      address = :rand.uniform(memory.size)

      written_memory = Memory.write(memory, address, data)

      assert %Memory{} = written_memory
      assert memory == written_memory
    end

    test "should return a memory struct unchanged when address is out of bounds of memory" do
      memory = Memory.new(10)

      data_size = memory.size |> Integer.floor_div(2) |> :rand.uniform()
      data = Enum.to_list(1..data_size)
      address = memory.size

      written_memory = Memory.write(memory, address, data)

      assert %Memory{} = written_memory
      assert memory == written_memory
    end

    test "should return a memory struct with data written on the given address" do
      memory = Memory.new(10)

      data_size = Integer.floor_div(memory.size, 2)
      data = Enum.to_list(1..data_size)
      address = 0x0

      written_memory = Memory.write(memory, address, data)

      assert %Memory{} = written_memory
      assert [1, 2, 3, 4, 5, 0, 0, 0, 0, 0] == written_memory.data
    end

    test "should return a memory struct with data truncated on the given address when data overflows memory" do
      memory = Memory.new(10)

      data = Enum.to_list(1..memory.size)
      address = 0x6

      written_memory = Memory.write(memory, address, data)

      assert %Memory{} = written_memory
      assert [0, 0, 0, 0, 0, 0, 1, 2, 3, 4] == written_memory.data
    end
  end
end
