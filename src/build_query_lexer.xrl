
Definitions.

IDENTIFIER    = [a-zA-Z][A-Za-z0-9_]*

Rules.

%% a number
[0-9]+ : {token, {number, TokenLine, list_to_integer(TokenChars)}}.

%% comparison operators
= : {token, {operator, TokenLine, '=='}}.
!= : {token, {operator, TokenLine, '!='}}.
< : {token, {operator, TokenLine, '<'}}.
> : {token, {operator, TokenLine, '>'}}.
<= : {token, {operator, TokenLine, '>='}}.
>= : {token, {operator, TokenLine, '<='}}.
like     : {token, {operator, TokenLine, 'ilike'}}.
%contains : {token, {operator, TokenLine, cmp_contains}}.

%% inclusion
in       : {token, {cmp_in, TokenLine}}.

%% aggregate functions
count : {token, {aggregate, TokenLine, count}}.
sum   : {token, {aggregate, TokenLine, sum}}.

%% open/close parens
\( : {token, {left_paren, TokenLine}}.
\) : {token, {right_paren, TokenLine}}.
\[ : {token, {'[', TokenLine}}.
\] : {token, {']', TokenLine}}.

%% arithmetic operators
\. : {token, {dot, TokenLine}}.
\, : skip_token.

%% Reserver keywords
as           : {token, {as, TokenLine}}.
and          : {token, {boolean_mult, TokenLine}}.
or           : {token, {boolean_add, TokenLine}}.
not          : {token, {boolean_negate, TokenLine}}.
where        : {token, {where, TokenLine}}.
true         : {token, {true, TokenLine}}.
false        : {token, {false, TokenLine}}.
between      : {token, {between, TokenLine}}.
select       : {token, {select, TokenLine}}.
from         : {token, {from, TokenLine}}.
join         : {token, {join, TokenLine}}.
inner\sjoin  : {token, {join, TokenLine}}.
left\sjoin   : {token, {left_join, TokenLine}}.
right\sjoin  : {token, {right_join, TokenLine}}.

%% Identifiers
{IDENTIFIER}  : {token, {identifier, TokenLine, TokenChars}}.

'[^']*'  : {token, {quoted, TokenLine, TokenChars}}.
"[^"]*"  : {token, {quoted, TokenLine, TokenChars}}.

%% white space
[\s\n\r\t]+           : skip_token.

Erlang code.

oid(Oid) ->
    S = tl(lists:droplast(Oid)),
    L = string:split(S, ".", all),
    lists:map(fun list_to_integer/1, L).
