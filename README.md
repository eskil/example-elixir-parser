# ExampleElixirParser

Yet another how to make a elixir parser package using leex and yecc.

## Helpful links

I read these things to get a feel for how yacc/lex (yecc/leex) in elixir works.

 * http://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/
 * https://cameronp.svbtle.com/how-to-use-leex-and-yecc
 * https://github.com/knutin/calx
 * http://blog.rusty.io/2011/02/08/leex-and-yecc/

And of course the canonical documentation

 * http://erlang.org/doc/man/leex.html
 * http://erlang.org/doc/man/yecc.html
 

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

Define a lexer in `src/example_elixir_parser_lexer.xrl`. Since the file name is used as the module name, I don't use something short ala `parser.xrl`.

   ```elixir
   ```

Define a yacc style grammer in `src/example_elixir_parser.yrl`

   ```elixir
   ```

To mix.exs, add

   ```elixir
   def project do
     [app: :my_parser,
       ...
       escript: [main_module: ExampleElixirParser.Main],
     ]
   ```

Define a `main/1` function in `lib/main.ex` under `ExampleElixirParser.Main.main/1`.

   ```elixir
   
   ```

Build and run

   ```bash
   mix escript.build && ./example_elixir_parser "my code"
   ...
   ```

