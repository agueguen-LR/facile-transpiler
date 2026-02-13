%{
#include <stdlib.h>
#include <stdio.h>

extern int yylex(void);
extern int yyerror(const char *msg);
extern int yylineno;
%}

%define parse.error verbose

%token TOK_IF "if"
%token TOK_THEN "then"
%token TOK_SEMI_COLON ";"
%token TOK_ASSIGN ":="
%token TOK_ADD "+"
%token TOK_SUB "-"
%token TOK_MUL "*"
%token TOK_DIV "/"
%token TOK_IDENTIFIER "identifier"
%token TOK_READ "read"
%token TOK_PRINT "print"
%token TOK_ENDIF "endif"
%token TOK_ELSEIF "elseif"
%token TOK_END "end"
%token TOK_ELSE "else"
%token TOK_WHILE "while"
%token TOK_DO "do"
%token TOK_ENDWHILE "endwhile"
%token TOK_CONTINUE "continue"
%token TOK_BREAK "break"
%token TOK_LPAREN "("
%token TOK_RPAREN ")"
%token TOK_TRUE "true"
%token TOK_FALSE "false"
%token TOK_SUPEQ ">="
%token TOK_SUBEQ "<="
%token TOK_MORE_THAN ">"
%token TOK_LESS_THAN "<"
%token TOK_EQ "="
%token TOK_DIFF "#"
%token TOK_NOT "not"
%token TOK_AND "and"
%token TOK_OR "or"
%token TOK_NUMBER "number"


%%
program: code;

code: code instruction |;

instruction: assign;

assign: identifier TOK_ASSIGN expression TOK_SEMI_COLON;

expression: identifier | number;

identifier: TOK_IDENTIFIER;

number: TOK_NUMBER;
%%

/*
* file: facile.y
* version: 0.2.0
*/

int yyerror(const char *msg) {
	fprintf(stderr, "Line %d: %s\n", yylineno, msg);
}

int main(int argc, char *argv[]) {
	yyparse();
	return EXIT_SUCCESS;
}
