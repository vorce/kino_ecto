Nonterminals
query terms.

Terminals
select_fields from.
% select from where var number operator plus minus mult divd lparen rparen.

Rootsymbol query.

query -> terms : {terms, extract_token('$1')}.
terms -> select_fields : extract_token('$1').
terms -> from : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
