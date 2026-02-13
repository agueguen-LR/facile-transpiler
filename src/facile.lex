%{
	#include <assert.h>

	#include "facile.y.h"
%}

%option yylineno

%%

if {
	assert(printf("'if' found"));
	return TOK_IF;
}

then {
	assert(printf("'then' found"));
	return TOK_THEN;
}

read {
	assert(printf("'read' found"));
	return TOK_READ;
}

print {
	assert(printf("'print' found"));
	return TOK_PRINT;
}

endif {
	assert(printf("'endif' found"));
	return TOK_ENDIF;
}

elseif {
	assert(printf("'elseif' found"));
	return TOK_ELSEIF;
}

end {
	assert(printf("'end' found"));
	return TOK_END;
}

else {
	assert(printf("'else' found"));
	return TOK_ELSE;
}

while {
	assert(printf("'while' found"));
	return TOK_WHILE;
}

do {
	assert(printf("'do' found"));
	return TOK_DO;
}

endwhile {
	assert(printf("'endwhile' found"));
	return TOK_ENDWHILE;
}

continue {
	assert(printf("'continue' found"));
	return TOK_CONTINUE;
}

break {
	assert(printf("'break' found"));
	return TOK_BREAK;
}

true {
	assert(printf("'true' found"));
	return TOK_TRUE;
}

false {
	assert(printf("'false' found"));
	return TOK_FALSE;
}

not {
	assert(printf("'not' found"));
	return TOK_NOT;
}

and {
	assert(printf("'and' found"));
	return TOK_AND;
}

or {
	assert(printf("'or' found"));
	return TOK_OR;
}

";" {
	assert(printf("';' found"));
	return TOK_SEMI_COLON;
}

"+" {
	assert(printf("'+' found"));
	return TOK_ADD;
}

"-" {
	assert(printf("'-' found"));
	return TOK_SUB;
}

"*" {
	assert(printf("'*' found"));
	return TOK_MUL;
}

"/" {
	assert(printf("'/' found"));
	return TOK_DIV;
}

":=" {
	assert(printf("':=' found"));
	return TOK_ASSIGN;
}

"(" {
	assert(printf("'(' found"));
	return TOK_LPAREN;
}

")" {
	assert(printf("')' found"));
	return TOK_RPAREN;
}

">=" {
	assert(printf("'>=' found"));
	return TOK_SUPEQ;
}

"<=" {
	assert(printf("'<=' found"));
	return TOK_SUBEQ;
}

">" {
	assert(printf("'>' found"));
	return TOK_MORE_THAN;
}

"<" {
	assert(printf("'<' found"));
	return TOK_LESS_THAN;
}

"=" {
	assert(printf("'=' found"));
	return TOK_EQ;
}

"#" {
	assert(printf("'#' found"));
	return TOK_DIFF;
}

[a-zA-Z][a-zA-Z0-9_]* {
	assert(printf("identifier '%s(%d)' found", yytext, yyleng));
	return TOK_IDENTIFIER;
}

0|[1-9][0-9]* {
	assert(printf("number '%s(%d)' found", yytext, yyleng));
	return TOK_NUMBER;
}

[ \t\n] ;

. {
	return yytext[0];
}
%%

/*
* file: facile.lex
* version: 0.2.0
*/
