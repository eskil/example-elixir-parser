# ExampleElixirParser

## How to make a elixir parser package

### Helpful links

I read these things to get a feel for how yacc/lex (yecc/leex) in elixir works.

 * http://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/
 * https://cameronp.svbtle.com/how-to-use-leex-and-yecc
 * https://github.com/knutin/calx

### Quick start

   ```bash
   mix new example_elixir_parser --module ExampleElixirParser

   cd example_elixir_parser
   git init .
   git add .
   git commit -m "Initial commit"

   mkdir src
   # create src/parser.yrl and src/parser.xrl
   git add src
   git commit -m "Add parser"
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

   ```      

Build and run

   ```bash
   mix escript.build && ./example_elixir_parser "my code"
   ...
   ```

