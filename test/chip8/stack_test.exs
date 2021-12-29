defmodule Chip8.StackTest do
  use ExUnit.Case, async: true

  alias Chip8.Stack

  describe "new/0" do
    test "should return a stack struct" do
      stack = Stack.new()

      assert %Stack{} = stack
    end
  end

  describe "pop/1" do
    test "should return a tuple with an integer and a stack" do
      empty_stack = Stack.new()
      item = :rand.uniform(0xFFF)
      stack = put_in(empty_stack.data, [item])
      stack = put_in(stack.size, 1)

      pop_result = Stack.pop(stack)

      assert {item, empty_stack} == pop_result
    end

    test "should return a tuple with the last item added to the stack" do
      stack = Stack.new()
      first_item = :rand.uniform(0xFFF)
      last_item = :rand.uniform(0xFFF)
      stack = put_in(stack.data, [last_item, first_item])
      stack = put_in(stack.size, 2)

      {popped_item, _popped_stack} = Stack.pop(stack)

      assert last_item == popped_item
    end

    test "should return a tuple with the the popped stack" do
      stack = Stack.new()
      first_item = :rand.uniform(0xFFF)
      last_item = :rand.uniform(0xFFF)
      stack = put_in(stack.data, [last_item, first_item])
      stack = put_in(stack.size, 2)

      {_popped_item, popped_stack} = Stack.pop(stack)

      assert [first_item] == popped_stack.data
      assert 1 == popped_stack.size
    end

    test "should return a tuple with nil and the stack when the stack is empty" do
      stack = Stack.new()

      pop_result = Stack.pop(stack)

      assert {nil, stack} == pop_result
    end
  end

  describe "push/2" do
    test "should return a stack struct" do
      stack = Stack.new()

      value = :rand.uniform(0xFFF)
      pushed_stack = Stack.push(stack, value)

      assert %Stack{} = pushed_stack
    end

    test "should return a stack with the given item on top" do
      stack = Stack.new()

      value = :rand.uniform(0xFFF)
      pushed_stack = Stack.push(stack, value)

      assert [value] == pushed_stack.data
    end

    test "should return a stack with the size incremented" do
      stack = Stack.new()

      value = :rand.uniform(0xFFF)
      pushed_stack = Stack.push(stack, value)

      assert 1 == pushed_stack.size
    end
  end
end
