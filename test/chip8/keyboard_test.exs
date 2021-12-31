defmodule Chip8.KeyboardTest do
  use ExUnit.Case, async: true

  alias Chip8.Keyboard

  describe "new/0" do
    test "should return a keyboard struct" do
      keyboard = Keyboard.new()

      assert %Keyboard{} = keyboard
    end
  end
end
