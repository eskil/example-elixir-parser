defmodule ExampleElixirParser.Mixfile do
  use Mix.Project

  def project do
    [app: :example_elixir_parser,
     version: "0.1.0",
     elixir: "~> 1.19",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: ExampleElixirParser.Main],
     deps: deps(),
     compilers: [:yecc, :leex] ++ Mix.compilers(),
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end
end
