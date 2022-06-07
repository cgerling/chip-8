defmodule Chip8.MixProject do
  use Mix.Project

  def project do
    [
      app: :chip8,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v0.1.0",
      groups_for_modules: [
        Interpreter: [
          Chip8.Runtime.Display,
          Chip8.Runtime.Display.Sprite,
          Chip8.Runtime.Font,
          Chip8.Runtime.Instruction,
          Chip8.Runtime.Instruction.Argument.Address,
          Chip8.Runtime.Instruction.Argument.Byte,
          Chip8.Runtime.Instruction.Argument.Nibble,
          Chip8.Runtime.Instruction.Argument.Register,
          Chip8.Runtime.Keyboard,
          Chip8.Runtime.Memory,
          Chip8.Runtime.Timer,
          Chip8.Runtime.VRegisters
        ],
        "Instruction Set": [
          Chip8.Runtime.Instruction.ADD,
          Chip8.Runtime.Instruction.AND,
          Chip8.Runtime.Instruction.CALL,
          Chip8.Runtime.Instruction.CLS,
          Chip8.Runtime.Instruction.DRW,
          Chip8.Runtime.Instruction.JP,
          Chip8.Runtime.Instruction.LD,
          Chip8.Runtime.Instruction.OR,
          Chip8.Runtime.Instruction.RET,
          Chip8.Runtime.Instruction.RND,
          Chip8.Runtime.Instruction.SE,
          Chip8.Runtime.Instruction.SHL,
          Chip8.Runtime.Instruction.SHR,
          Chip8.Runtime.Instruction.SKNP,
          Chip8.Runtime.Instruction.SKP,
          Chip8.Runtime.Instruction.SNE,
          Chip8.Runtime.Instruction.SUB,
          Chip8.Runtime.Instruction.SUBN,
          Chip8.Runtime.Instruction.SYS,
          Chip8.Runtime.Instruction.XOR
        ]
      ]
    ]
  end
end
