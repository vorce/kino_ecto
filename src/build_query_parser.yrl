Nonterminals select_stmt select_opts select_expr_list select_expr table_references table_reference table_factor opt_where opt_where_list opt_as_alias grouping binary_expr expr.
Terminals identifier select from where operator number as quoted boolean_mult boolean_add left_paren right_paren.
Rootsymbol select_stmt.

select_stmt -> select select_opts select_expr_list : {select, '$2', '$3'}.
select_stmt -> select select_opts select_expr_list from table_references opt_where : {select, extract_value('$2'), '$3', '$5', '$6'}.

select_opts -> expr : '$1'.
select_expr_list -> '$empty' : nil.
select_expr_list -> select_expr : '$1'.
select_expr -> expr opt_as_alias : '$1'.

table_references -> table_reference : {from, extract_value('$1')}.
table_reference -> table_factor : '$1'.
table_factor -> expr : '$1'.

opt_where -> '$empty' : nil.
opt_where -> where opt_where_list : {where, '$2'}.

opt_where_list -> left_paren opt_where_list right_paren: {grouping, '$2'}.
opt_where_list -> boolean_mult binary_expr: {extract_token('$1'), '$2'}.
opt_where_list -> boolean_add binary_expr: {extract_token('$1'), '$2'}.
opt_where_list -> binary_expr: '$1'.

binary_expr -> expr operator expr : {extract_value('$2'), extract_value('$1'), extract_value('$3')}.
opt_as_alias -> as expr : '$2'.
expr -> quoted : '$1'.
expr -> identifier : '$1'.
expr -> number : '$1'.

Erlang code.

-import(string,[len/1, sub_string/3]). 

extract_value({_Token, _Line, Value}) -> Value.
extract_token({Token, _Line}) -> Token.
remove_line({Token, _Line, Value}) -> {Token, Value}.
remove_quotes({_Token, _Line, Value}) -> list_to_binary(sub_string(Value, 2, len(Value)-1)).
