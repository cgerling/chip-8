defmodule Chip8.Interpreter.Instruction do
  @moduledoc """
  Module to interact with interpreter's _opcodes_.

  The interpreter's instruction set includes 36 instructions, that allow
  programs to perform operations of arithmetic, control flow, data manipulation,
  graphics, and logical. 

  All instructions are `2 bytes` long and are stored in a **big-endian** format. 
  In memory, the interpreter assumes that all instructions should start at an
  even address, and needs to be taken into account when adding
  sprite data, see `Chip8.Interpreter.Display.Sprite` for more information.

  ## Instruction Definition

  Instructions are grouped in modules that represent their operation and
  share the same mnemonic, making different _opcodes_ as simple variants. 
  Inside each module, there is a table describing all variants supported
  by the module, each variant specifies its _opcode_ and the effects applied
  into the interpreter once it is invoked.

  Since each variant supports a different type of value as operands 
  (i.e. arguments), the notation below is used to compactly describe the use
  of each part inside the _opcode_:

  * `nnn` or `address` - A 12-bit integer value, representing an memory address
  * `n` or `nibble` - A 4-bit integer value, representing a literal number
  * `kk` or `byte` - An 8-bit integer value, representing a literal number
  * `x` or `Vx` - A 4-bit integer value, representing one of the 16 variable registers
  * `y` or `Vy` - A 4-bit integer value, representing one of the 16 variable registers

  ## Decode
  #
  When decoding an instruction, the given `2 bytes` list is transformed into a 
  `t:Chip8.Interpreter.Instruction.t/0`, containing the module that supports the
  given _opcode_ as one of its variants and the arguments, that was also
  parsed into its equivalent struct i.e. an `nnn` address is transformed into a 
  `t:Chip8.Interpreter.Instruction.Argument.Address.t/0`.

  In case an unknown segment of _bytes_ is given, an error is returned.
  """

  alias Chip8.Interpreter
  alias Chip8.Interpreter.Instruction.Argument.Address
  alias Chip8.Interpreter.Instruction.Argument.Byte
  alias Chip8.Interpreter.Instruction.Argument.Nibble
  alias Chip8.Interpreter.Instruction.Argument.Register
  alias Chip8.Interpreter.Instruction.Decoder
  alias Chip8.Interpreter.Memory

  @type arguments() ::
          {}
          | {Address.t()}
          | {Register.t()}
          | {Register.t(), Address.t()}
          | {Register.t(), Byte.t()}
          | {Register.t(), Register.t()}
          | {Register.t(), Register.t(), Nibble.t()}

  @callback new(arguments()) :: t()
  @callback execute(Interpreter.t(), arguments()) :: Interpreter.t()

  @enforce_keys [:arguments, :module]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
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

  @spec execute(t(), Interpreter.t()) :: Interpreter.t()
  def execute(%__MODULE__{} = instruction, %Interpreter{} = interpreter) do
    %__MODULE__{arguments: arguments, module: module} = instruction

    module.execute(interpreter, arguments)
  end

  @spec byte_size() :: integer()
  def byte_size, do: 2
end
