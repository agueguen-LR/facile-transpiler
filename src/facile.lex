%{
	#include <assert.h>

	#define TOK_IF 258
	#define TOK_THEN 259
	#define TOK_SEMI_COLON 260
	#define TOK_ASSIGN 261
	#define TOK_ADD 262
	#define TOK_SUB 263
	#define TOK_MUL 264
	#define TOK_DIV 265
	#define TOK_IDENTIFIER 266
	#define TOK_READ 267
	#define TOK_PRINT 268
	#define TOK_ENDIF 269
	#define TOK_ELSEIF 270
	#define TOK_END 271
	#define TOK_ELSE 272
	#define TOK_WHILE 273
	#define TOK_DO 274
	#define TOK_ENDWHILE 275
	#define TOK_CONTINUE 276
	#define TOK_BREAK 277
	#define TOK_LPAREN 278
	#define TOK_RPAREN 279
	#define TOK_TRUE 280
	#define TOK_FALSE 281
	#define TOK_SUPEQ 282
	#define TOK_SUBEQ 283
	#define TOK_MORE_THAN 284
	#define TOK_LESS_THAN 285
	#define TOK_EQ 286
	#define TOK_DIFF 287
	#define TOK_NOT 288
	#define TOK_AND 289
	#define TOK_OR 290
	#define TOK_NUMBER 291
%}

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
* version: 0.1.0
*/
