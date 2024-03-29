defmodule Chip8.MixProject do
  use Mix.Project

  @version "1.1.0"
  @repository_url "https://github.com/cgerling/chip-8"

  def project do
    [
      app: :chip8,
      version: @version,
      elixir: "~> 1.13",
      description: "Core library for a Chip-8 interpreter",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    []
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

  def package do
    [
      exclude_patterns: ["priv/plts"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repository_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: @repository_url,
      groups_for_modules: [
        Interpreter: [
          Chip8.Interpreter.Display,
          Chip8.Interpreter.Display.Coordinates,
          Chip8.Interpreter.Display.Sprite,
          Chip8.Interpreter.Font,
          Chip8.Interpreter.Instruction,
          Chip8.Interpreter.Instruction.Argument,
          Chip8.Interpreter.Instruction.Argument.Address,
          Chip8.Interpreter.Instruction.Argument.Byte,
          Chip8.Interpreter.Instruction.Argument.Nibble,
          Chip8.Interpreter.Instruction.Argument.Register,
          Chip8.Interpreter.Keyboard,
          Chip8.Interpreter.Memory,
          Chip8.Interpreter.Timer,
          Chip8.Interpreter.VRegisters
        ],
        "Instruction Set": [
          Chip8.Interpreter.Instruction.ADD,
          Chip8.Interpreter.Instruction.AND,
          Chip8.Interpreter.Instruction.CALL,
          Chip8.Interpreter.Instruction.CLS,
          Chip8.Interpreter.Instruction.DRW,
          Chip8.Interpreter.Instruction.JP,
          Chip8.Interpreter.Instruction.LD,
          Chip8.Interpreter.Instruction.OR,
          Chip8.Interpreter.Instruction.RET,
          Chip8.Interpreter.Instruction.RND,
          Chip8.Interpreter.Instruction.SE,
          Chip8.Interpreter.Instruction.SHL,
          Chip8.Interpreter.Instruction.SHR,
          Chip8.Interpreter.Instruction.SKNP,
          Chip8.Interpreter.Instruction.SKP,
          Chip8.Interpreter.Instruction.SNE,
          Chip8.Interpreter.Instruction.SUB,
          Chip8.Interpreter.Instruction.SUBN,
          Chip8.Interpreter.Instruction.SYS,
          Chip8.Interpreter.Instruction.XOR
        ]
      ]
    ]
  end
end
