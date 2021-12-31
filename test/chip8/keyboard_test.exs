defmodule Chip8.KeyboardTest do
  use ExUnit.Case, async: true

  alias Chip8.Keyboard

  describe "new/0" do
    test "should return a keyboard struct" do
      keyboard = Keyboard.new()

      assert %Keyboard{} = keyboard
    end
  end

  describe "is_pressed?/2" do
    test "should return true when given key is pressed" do
      keyboard = Keyboard.new()
      key = :rand.uniform(0xF)
      keyboard = put_in(keyboard.keys[key], :pressed)

      is_pressed? = Keyboard.is_pressed?(keyboard, key)

      assert is_pressed?
    end

    test "should return false when given key is not pressed" do
      keyboard = Keyboard.new()
      key = :rand.uniform(0xF)

      is_pressed? = Keyboard.is_pressed?(keyboard, key)

      refute is_pressed?
    end
  end
end
