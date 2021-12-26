defmodule Chip8.RuntimeTest do
  use ExUnit.Case, async: true

  alias Chip8.Runtime

  describe "new/0" do
    test "should return a runtime struct" do
      system = Runtime.new()

      assert %Runtime{} = system
    end
  end
end
