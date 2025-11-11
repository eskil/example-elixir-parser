all:
	mix deps.clean --all
	mix deps.get
	mix compile
	mix escript.build
	./example_elixir_parser example/input.txt
