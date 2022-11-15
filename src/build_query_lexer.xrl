Definitions.

NUMBER = [0-9]+
WORD = [a-zA-Z][A-Za-z0-9_]+
WHITESPACE = [\s\t\n\r]
COMMA = ,

FIELDS = select\s[a-z0-9_.]+((.\s\w+\b)*)
FROM_TABLE = from\s[a-z0-9_.]+

Rules.
{WHITESPACE} : skip_token.
{COMMA}      : skip_token.

%% comparison operators
=           : {token, {operator, TokenLine, '='}}.
!=          : {token, {operator, TokenLine, '!='}}.
<           : {token, {operator, TokenLine, '<'}}.
>           : {token, {operator, TokenLine, '>'}}.
<=          : {token, {operator, TokenLine, '>='}}.
>=          : {token, {operator, TokenLine, '<='}}.
like        : {token, {operator, TokenLine, 'ilike'}}.

%% Query private words
{FIELDS}     : {token, {select_fields, TokenLine, extract_fields(TokenChars)}}.
{FROM_TABLE} : {token, {from, TokenLine, extract_from(TokenChars)}}.
where        : {token, {where, TokenLine}}.
join         : {token, {inner_join, TokenLine}}.

%% arithmetic operators
\+          : {token, {plus, TokenLine}}.
\-          : {token, {minus, TokenLine}}.
\*          : {token, {mult, TokenLine}}.
\/          : {token, {divd, TokenLine}}.
\(          : {token, {lparen, TokenLine}}.
\)          : {token, {rparen, TokenLine}}.

{NUMBER}    : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
% {WORD}      : {token, {var, TokenLine, list_to_atom(TokenChars)}}.

Erlang code.

extract_token([_, _, Fields]) -> Fields.
extract_fields(Fields) -> extract_token(string:replace(Fields, "select ", "", all)).
extract_from(Fields) -> extract_token(string:replace(Fields, "from ", "", all)).
