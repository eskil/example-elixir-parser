defmodule ExampleElixirParser.Main do
  def process_tree({:error, result}) do
    IO.puts "\nParse error"
    IO.inspect result
  end

  def process_tree({:ok, tree}) do
    IO.puts "\nParse tree"
    IO.inspect tree
  end
  
  def main(args) do
    filename = Enum.fetch!(args, 0)

    IO.puts "Parsing #{filename}"
    text = File.read!(filename)

    {:ok, tokens, line} = :example_elixir_parser_lexer.string(String.to_char_list(text))
    IO.puts "Parsed #{filename}, stopped at line #{line}"
    IO.puts "\nTokens:"
    IO.inspect tokens

    process_tree(:example_elixir_parser.parse(tokens))
  end
end
