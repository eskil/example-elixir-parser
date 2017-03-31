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
