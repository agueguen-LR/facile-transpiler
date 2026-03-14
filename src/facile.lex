/*
* @file facile.lex
* @author agueguen-LR <agueguen@proton.me>
* @date 2026
*/

%{
	#include <assert.h>
	#include <glib.h>

	#include "facile.y.h"

	int yycolumn = 0;
	#define YY_USER_ACTION \
    yylloc.first_line = yylineno; \
    yylloc.first_column = yycolumn; \
    yylloc.last_line = yylineno; \
    yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;
%}

%option yylineno

%%

if {
	assert(printf("'if' found\n"));
	return TOK_IF;
}

then {
	assert(printf("'then' found\n"));
	return TOK_THEN;
}

read {
	assert(printf("'read' found\n"));
	return TOK_READ;
}

print {
	assert(printf("'print' found\n"));
	return TOK_PRINT;
}

endif {
	assert(printf("'endif' found\n"));
	return TOK_ENDIF;
}

elseif {
	assert(printf("'elseif' found\n"));
	return TOK_ELSEIF;
}

end {
	assert(printf("'end' found\n"));
	return TOK_END;
}

else {
	assert(printf("'else' found\n"));
	return TOK_ELSE;
}

while {
	assert(printf("'while' found\n"));
	return TOK_WHILE;
}

do {
	assert(printf("'do' found\n"));
	return TOK_DO;
}

endwhile {
	assert(printf("'endwhile' found\n"));
	return TOK_ENDWHILE;
}

continue {
	assert(printf("'continue' found\n"));
	return TOK_CONTINUE;
}

break {
	assert(printf("'break' found\n"));
	return TOK_BREAK;
}

true {
	assert(printf("'true' found\n"));
	return TOK_TRUE;
}

false {
	assert(printf("'false' found\n"));
	return TOK_FALSE;
}

not {
	assert(printf("'not' found\n"));
	return TOK_NOT;
}

and {
	assert(printf("'and' found\n"));
	return TOK_AND;
}

or {
	assert(printf("'or' found\n"));
	return TOK_OR;
}

";" {
	assert(printf("';' found\n\n"));
	return TOK_SEMI_COLON;
}

"+" {
	assert(printf("'+' found\n"));
	return TOK_ADD;
}

"-" {
	assert(printf("'-' found\n"));
	return TOK_SUB;
}

"*" {
	assert(printf("'*' found\n"));
	return TOK_MUL;
}

"/" {
	assert(printf("'/' found\n"));
	return TOK_DIV;
}

":=" {
	assert(printf("':=' found\n"));
	return TOK_ASSIGN;
}

"(" {
	assert(printf("'(' found\n"));
	return TOK_LPAREN;
}

")" {
	assert(printf("')' found\n"));
	return TOK_RPAREN;
}

">=" {
	assert(printf("'>=' found\n"));
	return TOK_SUPEQ;
}

"<=" {
	assert(printf("'<=' found\n"));
	return TOK_SUBEQ;
}

">" {
	assert(printf("'>' found\n"));
	return TOK_MORE_THAN;
}

"<" {
	assert(printf("'<' found\n"));
	return TOK_LESS_THAN;
}

"=" {
	assert(printf("'=' found\n"));
	return TOK_EQ;
}

"#" {
	assert(printf("'#' found\n"));
	return TOK_DIFF;
}

[a-zA-Z][a-zA-Z0-9_]* {
	assert(printf("identifier '%s(%d)' found\n", yytext, yyleng));
	yylval.string = yytext;
	return TOK_IDENTIFIER;
}

0|[1-9][0-9]* {
	assert(printf("number '%s(%d)' found\n", yytext, yyleng));
	sscanf(yytext, "%lu", &yylval.number);
	return TOK_NUMBER;
}

[ \t] ;
[\n] { yycolumn = 0; }

. {
	return yytext[0];
}
%%
