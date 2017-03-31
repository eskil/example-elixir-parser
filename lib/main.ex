defmodule ExampleElixirParser.Main do
  def reduce_to_value({:int, _line, value}, _state) do
    value
  end

  def reduce_to_value({:add_op, lhs, rhs}, state) do
    reduce_to_value(lhs, state) + reduce_to_value(rhs, state)
  end

  def reduce_to_value({:mul_op, lhs, rhs}, state) do
    reduce_to_value(lhs, state) * reduce_to_value(rhs, state)
  end

  def reduce_to_value({:div_op, lhs, rhs}, state) do
    reduce_to_value(lhs, state) / reduce_to_value(rhs, state)
  end

  def reduce_to_value({:atom, _line, atom}, state) do
    state[atom]
  end
  
  def process_tree([{:assign, {:atom, _line, lhs}, rhs} | tail], state) do
    rhs_value = reduce_to_value(rhs, state)
    IO.puts "Evaluated #{lhs} to #{rhs_value}"
    process_tree(tail, Map.merge(state, %{lhs => rhs_value}))
  end

  def process_tree([], state) do
    state
  end

  def process_parse({:error, result}) do
    IO.puts "\nParse error"
    IO.inspect result
  end

  def process_parse({:ok, tree}) do
    IO.puts "\nParse tree"
    IO.inspect tree, pretty: true
    IO.puts "\nEvalutions"
    state = process_tree(tree, %{})
    IO.puts "\nFinal state"
    IO.inspect state, pretty: true
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
