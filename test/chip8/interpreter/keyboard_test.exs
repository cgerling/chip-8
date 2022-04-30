defmodule Chip8.Interpreter.KeyboardTest do
  use ExUnit.Case, async: true

  alias Chip8.Interpreter.Keyboard

  describe "new/0" do
    test "should return a keyboard struct" do
      keyboard = Keyboard.new()

      assert %Keyboard{} = keyboard
    end
  end

  describe "keys/0" do
    test "should return a list of all keys" do
      keys = Keyboard.keys()

      assert Enum.to_list(0x0..0xF) == keys
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

  describe "press_key/2" do
    test "should return a keyboard with the given key pressed" do
      keyboard = Keyboard.new()
      key = :rand.uniform(0xF)

      pressed_keyboard = Keyboard.press_key(keyboard, key)

      assert Keyboard.is_pressed?(pressed_keyboard, key)
    end

    test "should return a keyboard unchanged when the given press is already pressed" do
      key = :rand.uniform(0xF)
      keyboard = Keyboard.new() |> Keyboard.press_key(key)

      pressed_keyboard = Keyboard.press_key(keyboard, key)

      assert pressed_keyboard == keyboard
    end
  end

  describe "release_key/2" do
    test "should return a keyboard with the given key not pressed" do
      keyboard = Keyboard.new()
      key = :rand.uniform(0xF)

      released_keyboard = Keyboard.release_key(keyboard, key)

      refute Keyboard.is_pressed?(released_keyboard, key)
    end

    test "should return a keyboard unchanged when the given key is already not pressed" do
      keyboard = Keyboard.new()
      key = :rand.uniform(0xF)

      released_keyboard = Keyboard.release_key(keyboard, key)

      assert released_keyboard == keyboard
    end
  end
end
