defmodule Chip8.Runtime.Instruction.Argument.Register do
  @moduledoc false

  @enforce_keys [:value]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          value: 0x0..0xF | :bcd | :dt | :font | :i | :keyboard | :memory | :st
        }

  @spec v(0x0..0xF) :: t()
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
