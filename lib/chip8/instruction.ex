defmodule Chip8.Instruction do
  @moduledoc false

  alias Chip8.Runtime

  @type arguments :: %{atom() => term()}

  @callback execute(Runtime.t(), arguments()) :: Runtime.t()

  @enforce_keys [:arguments, :module]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          arguments: arguments(),
          module: module()
        }

  @spec new(module()) :: t()
  @spec new(module(), arguments()) :: t()
  def new(module, arguments \\ %{}) when is_atom(module) and is_map(arguments) do
    %__MODULE__{
      arguments: arguments,
      module: module
    }
  end
end
