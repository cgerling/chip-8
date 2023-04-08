defmodule Chip8.Interpreter.Instruction.Argument.Register do
  @moduledoc """
  A 4-bit integer value representing a data register or a label for one of the _pseudo-registers_.

  ## Pseudo-registers

  Name        | Description
  :---:       | :---
  `bcd`       | binary-coded decimal, it represents a computation rather than an actual value.
  `dt`        | delay timer, see `Chip8.Interpreter` for more information.
  `font`      | represents the built-in font.
  `i`         | register `I` of the interpreter, see `Chip8.Interpreter` for more information.
  `keyboard`  | reads the keyboard and reports key events, see `Chip8.Interpreter.Keyboard` for more information.
  `memory`    | access to the memory space, see `Chip8.Interpreter` for more information.
  `st`        | sound timer, see `Chip8.Interpreter` for more information.
  """

  alias Chip8.Interpreter.VRegisters

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          value: VRegisters.register() | :bcd | :dt | :font | :i | :keyboard | :memory | :st
        }

  @spec v(VRegisters.register()) :: t()
  def v(index) when is_integer(index) and index in 0x0..0xF do
    %__MODULE__{
      value: index
    }
  end

  @spec bcd() :: t()
  def bcd do
    %__MODULE__{
      value: :bcd
    }
  end

  @spec dt() :: t()
  def dt do
    %__MODULE__{
      value: :dt
    }
  end

  @spec font() :: t()
  def font do
    %__MODULE__{
      value: :font
    }
  end

  @spec i() :: t()
  def i do
    %__MODULE__{
      value: :i
    }
  end

  @spec keyboard() :: t()
  def keyboard do
    %__MODULE__{
      value: :keyboard
    }
  end

  @spec memory() :: t()
  def memory do
    %__MODULE__{
      value: :memory
    }
  end

  @spec st() :: t()
  def st do
    %__MODULE__{
      value: :st
    }
  end
end
