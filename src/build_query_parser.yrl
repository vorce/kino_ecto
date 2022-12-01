Nonterminals select_stmt select_opts select_expr_list select_expr table_references table_reference 
    table_factor opt_where expr opt_as_alias.
Terminals identifier select from where operator number as quoted boolean_mult boolean_add 
left_paren right_paren fieldname grouping dot comma distinct all all_fields.
Rootsymbol select_stmt.

select_stmt -> select select_opts select_expr_list : {select, '$2', '$3'}.
select_stmt -> select select_opts select_expr_list from table_references opt_where : {select, '$2', '$3', '$5', '$6'}.

select_opts -> '$empty' : nil.
select_opts -> distinct : {select_opts, '$1'}.
select_expr_list -> '$empty' : nil.
select_expr_list -> select_expr : {fields, '$1'}.
select_expr -> select_expr comma select_expr : {'$1', '$3'}.
select_expr -> all: {extract_token('$1')}.
select_expr -> expr : '$1'.

table_references -> table_reference : {from, '$1'}.
table_reference -> table_factor : '$1'.
table_factor -> expr opt_as_alias: {'$1', '$2'}.

opt_where -> '$empty' : nil.
opt_where -> where expr : {where, '$2'}.

opt_as_alias -> '$empty' : nil.
opt_as_alias -> as expr : {alias, '$2'}.

expr -> left_paren expr right_paren: {grouping, '$2'}.
expr -> expr boolean_mult expr: {booelan_mult, '$1', '$3'}.
expr -> expr boolean_add expr: {boolean_add, '$1', '$3'}.
expr -> expr operator expr : {extract_value('$2'), '$1', '$3'}.
expr -> identifier dot identifier : {fieldname, extract_value('$1'), '.', extract_value('$3')}.
expr -> quoted : {quoted, extract_value('$1')}.
expr -> identifier : extract_value('$1').
expr -> number : extract_value('$1').

Erlang code.

-import(string,[len/1, sub_string/3]). 

extract_value({_Token, _Line, Value}) -> Value.
extract_token({Token, _Line}) -> Token.
