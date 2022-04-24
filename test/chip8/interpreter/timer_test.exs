defmodule Chip8.Interpreter.TimerTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Timer

  describe "new/1" do
    test "should return a timer struct with a default value" do
      timer = Timer.new()

      assert %Timer{} = timer
      assert timer.value == 0
    end

    test "should return a timer struct with the given value" do
      value = :rand.uniform(0xFFFF)
      timer = Timer.new(value)

      assert %Timer{} = timer
      assert timer.value == value
    end
  end

  describe "tick/1" do
    test "should return a timer struct with value decremented by 1" do
      value = :rand.uniform(0xFFFF) + 1
      timer = Timer.new(value)

      ticked_timer = Timer.tick(timer)

      assert %Timer{} = ticked_timer
      assert ticked_timer == Timer.new(value - 1)
    end

    test "should return a timer struct unchanged when value is equals to 0" do
      timer = Timer.new()

      ticked_timer = Timer.tick(timer)

      assert ticked_timer == timer
    end

    test "should return a timer struct with value reseted when is less than 0" do
      timer = Timer.new(-1)

      ticked_timer = Timer.tick(timer)

      assert ticked_timer == Timer.new()
    end
  end
end
