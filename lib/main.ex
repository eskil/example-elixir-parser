defmodule ExampleElixirParser.Main do
  def process_tree([{:assign, {:atom, _, lhs}, rhs} | [tail]], state) do
    IO.puts "Assign"
    IO.puts "LHS"
    IO.inspect lhs
    IO.puts "RHS"
    IO.inspect rhs
    IO.puts "TAIL"
    IO.inspect tail
    IO.puts "STATE"
    IO.inspect state
    IO.puts ""
    process_tree(tail, state)
  end

  def process_tree([{:assign, {:atom, _, lhs}, rhs}], state) do
    IO.inspect lhs
    IO.inspect rhs
    IO.inspect state
  end

  def process_parse({:error, result}) do
    IO.puts "\nParse error"
    IO.inspect result
  end

  def process_parse({:ok, tree}) do
    IO.puts "\nParse tree"
    IO.inspect tree, pretty: true
    process_tree(tree, %{})
  end
  
  def main(args) do
    filename = Enum.fetch!(args, 0)

    IO.puts "Parsing #{filename}"
    text = File.read!(filename)

    {:ok, tokens, line} = :example_elixir_parser_lexer.string(String.to_char_list(text))
    IO.puts "Parsed #{filename}, stopped at line #{line}"
    IO.puts "\nTokens:"
    IO.inspect tokens

    process_parse(:example_elixir_parser.parse(tokens))
  end
end
