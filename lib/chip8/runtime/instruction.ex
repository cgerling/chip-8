defmodule Chip8.Runtime.Instruction do
  @moduledoc false

  alias Chip8.Runtime
  alias Chip8.Runtime.Instruction.Argument.Address
  alias Chip8.Runtime.Instruction.Argument.Byte
  alias Chip8.Runtime.Instruction.Argument.Nibble
  alias Chip8.Runtime.Instruction.Argument.Register
  alias Chip8.Runtime.Instruction.Decoder
  alias Chip8.Runtime.Memory

  @type arguments ::
          {}
          | {Address.t()}
          | {Register.t()}
          | {Register.t(), Address.t()}
          | {Register.t(), Byte.t()}
          | {Register.t(), Register.t()}
          | {Register.t(), Register.t(), Nibble.t()}

  @callback new(arguments()) :: t()
  @callback execute(Runtime.t(), arguments()) :: Runtime.t()

  @enforce_keys [:arguments, :module]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          arguments: arguments(),
          module: module()
        }

  defmacro __using__(_) do
    instruction_module = __MODULE__

    quote do
      @behaviour unquote(instruction_module)

      @impl unquote(instruction_module)
      def new(arguments) when is_tuple(arguments),
        do: unquote(instruction_module).new(__MODULE__, arguments)

      defoverridable new: 1
    end
  end

  @spec new(module(), arguments()) :: t()
  def new(module, arguments)
      when is_atom(module) and is_tuple(arguments) do
    %__MODULE__{
      arguments: arguments,
      module: module
    }
  end

  @spec decode(Memory.data()) :: {:ok, t()} | {:error, atom()}
  def decode(data), do: Decoder.decode(data)

  @spec execute(t(), Runtime.t()) :: Runtime.t()
  def execute(%__MODULE__{} = instruction, %Runtime{} = runtime) do
    %__MODULE__{arguments: arguments, module: module} = instruction

    module.execute(runtime, arguments)
  end

  @spec byte_size() :: integer()
  def byte_size, do: 2
end
