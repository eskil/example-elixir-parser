# ExampleElixirParser

Yet another how to make an elixir parser package using leex and
yecc. Leex and yecc are lex/yacc of erlang in the
[parsetools](http://erlang.org/doc/apps/parsetools/) part.

## Helpful links

The canonical documentation for leex and yecc 

 * http://erlang.org/doc/man/leex.html
 * http://erlang.org/doc/man/yecc.html

I also found these blog posts useful in getting started.

 * http://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/
 * https://cameronp.svbtle.com/how-to-use-leex-and-yecc
 * https://github.com/knutin/calx
 * http://blog.rusty.io/2011/02/08/leex-and-yecc/
 * https://arifishaq.wordpress.com/2014/01/22/playing-with-leex-and-yeec/
 * http://asquera.de/blog/2015-04-10/writing-a-commandline-app-in-elixir/

### Goal

This creates a parser for a simple calculator style language with
proper operator precedence. See [example/input.txt](example/input.txt)
for an example. In human, it's;

   * You can assign a value to variables, `:variable = 10`.
   * You can compute a value in assignments, `:variable = 3 * 4`.
   * You can refer to variables, `:variable = :other * 4`

   ```
   :a = 7
   :b = 4
   :result = :a + :b * 10 / 2
   ```

Which will evaluate to a state of

   ```
   a = 7
   b = 4
   result = 27
   ```

### Quick start

   ```bash
   mix new example_elixir_parser --module ExampleElixirParser

   cd example_elixir_parser
   git init .
   git add .
   git commit -m "Initial commit"

   mkdir src
   # create src/example_elixir_parser.yrl and src/example_elixir_parser_lexer.xrl see below
   git add src
   git commit -m "Add parser"
   ```

Define a lexer in `src/example_elixir_parser_lexer.xrl`. Since the
file name is used as the module name, I don't use something short ala
`parser.xrl`. The "trick" here is that `mix` compile will parse the
`.xrl` and `.yrl` files in `src/` into `.erl` files and they become
part of the build.

   ```erlang
   Definitions.
   INT        = [0-9]+
   NAME       = :[a-zA-Z_][a-zA-Z0-9_]*
   WHITESPACE = [\s\t\n\r]
   
   Rules.
   \+            : {token, {'+',  TokenLine}}.
   \-            : {token, {'-',  TokenLine}}.
   \*            : {token, {'*',  TokenLine}}.
   \/            : {token, {'/',  TokenLine}}.
   \=            : {token, {'=',  TokenLine}}.
   {NAME}        : {token, {atom, TokenLine, to_atom(TokenChars)}}.
   {INT}         : {token, {int,  TokenLine, TokenChars}}.
   {WHITESPACE}+ : skip_token.

   Erlang code.
   % Given a ":name", chop off : and return name as an atom.
   to_atom([$:|Chars]) ->
       list_to_atom(Chars).
   ```

Define a yacc style grammer in `src/example_elixir_parser.yrl`

   ```erlang
   Nonterminals
     root
     assignment
     assignments
     expr
   .

   Terminals
     int
     atom
     '+'
     '-'
     '*'
     '/'
     '='
   .

   Rootsymbol
      root
   .

   Right 100 '='.
   Left 300 '+'.
   Left 300 '-'.
   Left 400 '*'.
   Left 400 '/'.

   root -> assignments : '$1'.

   assignments -> assignment : '$1'.
   assignments -> assignment assignments : lists:merge('$1', '$2').

   assignment -> atom '=' expr : [{assign, '$1', '$3'}].

   expr -> int : unwrap('$1').
   expr -> atom : '$1'.
   expr -> expr '+' expr : {add_op, '$1', '$3'}.
   expr -> expr '-' expr : {sub_op, '$1', '$3'}.
   expr -> expr '*' expr : {mul_op, '$1', '$3'}.
   expr -> expr '/' expr : {div_op, '$1', '$3'}.

   Erlang code.

   unwrap({int, Line, Value}) -> {int, Line, list_to_integer(Value)}.   
   ```

Given the above example of 

   ```
   :a = 7
   :b = 4
   :result = :a + :b * 10 / 2
   ```

this will evaluate to a parse tree of

   ```
   [
     {:assign, {:atom, 1, :a}, {:int, 1, 7}},
     {:assign, {:atom, 2, :b}, {:int, 2, 4}},
     {:assign, {:atom, 3, :result},
       {:add_op,
         {:atom, 3, :a},
         {:div_op,
           {:mul_op,
             {:atom, 3, :b},
             {:int, 3, 10}},
           {:int, 3, 2}
         }
       }
     }
   ]
   ```

In the tree, the tuples contain the type, line number and
token. Eg. `{:int, 2, 4}` is the `4` at line 2.

To mix.exs, add

   ```elixir
   def project do
     [app: :my_parser,
       ...
       escript: [main_module: ExampleElixirParser.Main],
     ]
   ```

This is what `mix` uses to know what to use as the main entry for `mix
escript.build` generated
tools. [this](http://asquera.de/blog/2015-04-10/writing-a-commandline-app-in-elixir/)
blog post explains how to make command line tools in elixir with mix.

Define a `main/1` function in `lib/main.ex` under
`ExampleElixirParser.Main.main/1`. This will be responsible for
loading the file contents and feeding through the lexer and grammar.

   ```elixir
   defmodule ExampleElixirParser.Main do
     def main(args) do
       filename = Enum.fetch!(args, 0)
       text = File.read!(filename)
       {:ok, tokens, line} = :example_elixir_parser_lexer.string(String.to_char_list(text))
       {:ok, tree} = :example_elixir_parser.parse(tokens)
       process_tree(tree)
     end
   end
   ```

In `lib/example_elixir_parser.ex`, you can write your tree parser in `ExampleElixirParser`.

   ```elixir
   defmodule ExampleElixirParser do
      defp evaluate_tree([{:assign, {:atom, ...}, rhs} | tail], state) do
        .. your evaluation logic goes here..
      end

      defp evaluate_tree([], state) do
        state
      end

      def process_tree(tree) do
        evaluate_tree(tree, %{})
      end

      def parse_file(filename) do
        text = File.read!(filename)
        {:ok, tokens, line} = :example_elixir_parser_lexer.string(String.to_char_list(text))
        {:ok, tree} = :example_elixir_parser.parse(tokens)
        process_tree(tree)        
      end
   end
   ```

Look in [lib/example_elixir_parser.ex](lib/example_elixir_parser.ex)
and [lib/main.ex](lib/main.ex) for the full code.

Build and run

   ```bash
   mix escript.build && ./example_elixir_parser example/input.txt
   ...
   ```
which will yield

   ```erlang
   Parsing example/input.txt
   Parsed example/input.txt, stopped at line 4

   Tokens:
   [{:atom, 1, :a}, {:=, 1}, {:int, 1, '7'}, {:atom, 2, :b}, {:=, 2},
    {:int, 2, '4'}, {:atom, 3, :result}, {:=, 3}, {:atom, 3, :a}, {:+, 3},
     {:atom, 3, :b}, {:*, 3}, {:int, 3, '10'}, {:/, 3}, {:int, 3, '2'}]

   Parse tree
   [{:assign, {:atom, 1, :a}, {:int, 1, 7}},
    {:assign, {:atom, 2, :b}, {:int, 2, 4}},
     {:assign, {:atom, 3, :result},
       {:add_op,
         {:atom, 3, :a},
         {:div_op,
           {:mul_op,
             {:atom, 3, :b},
             {:int, 3, 10}},
           {:int, 3, 2}
         }
       }
     }
   ]

   Final state
   %{a: 7, b: 4, result: 27.0}
   ```

### Extra 

You can get a graph of the lexer by calling `:leex:file` with the `:dfa_graph` option.

   ```bash
   example_elixir_parser $ cd src
   example_elixir_parser/src $ iex
   iex(1)> :leex.file('example_elixir_parser_lexer', :dfa_graph)
   {:ok, './example_elixir_parser_lexer.erl'}
   ```

This generates a graphviz file

   ```
   example_elixir_parser_lexer.dot
   ```

   ```bash
   example_elixir_parser/src $ dot -Tpdf example_elixir_parser_lexer.dot -o example_elixir_parser_lexer.pdf
   example_elixir_parser/src $ open example_elixir_parser_lexer.pdf
   ```

You can see an example
[here](example/example_elixir_parser_lexer.pdf). I'll leave it to you
to decide if that's useful to you or not.
