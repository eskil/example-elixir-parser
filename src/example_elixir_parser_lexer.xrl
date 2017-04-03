% The Definitions section defines regexps for each token.

Definitions.

INT        = [0-9]+
NAME       = :[a-zA-Z_][a-zA-Z0-9_]*
WHITESPACE = [\s\t\n\r]


% The Rule section defines what to return for each token. Typically you'd
% want the TokenLine and the TokenChars to capture the matched
% expression.

Rules.

\+            : {token, {'+',  TokenLine}}.
\-            : {token, {'-',  TokenLine}}.
\*            : {token, {'*',  TokenLine}}.
\/            : {token, {'/',  TokenLine}}.
\=            : {token, {'=',  TokenLine}}.
{NAME}        : {token, {atom, TokenLine, to_atom(TokenChars)}}.
{INT}         : {token, {int,  TokenLine, TokenChars}}.
{WHITESPACE}+ : skip_token.


% The Erlang code section (which is mandatory), is where you can add
% erlang functions you can call in the Definitions. In this case we
% have a to_token to create a token for each named variable (this is
% not good style, but just to show how to use the code section).

Erlang code.

% Given a ":name", chop off : and return name as an atom.
to_atom([$:|Chars]) ->
    list_to_atom(Chars).