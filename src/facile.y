/*
* @file facile.y
* @author agueguen-LR <agueguen@proton.me>
* @date 2026
*/

%{
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <glib.h>
#include <ctype.h>

extern int yylex(void);
extern int yyerror(const char *msg);
extern int yylineno;

char* module_name;
FILE* stream;
GHashTable* table;
%}

%define parse.error verbose

%union {
	gulong number;
	gchar *string;
	GNode * node;
}

%token TOK_IF "if"
%token TOK_THEN "then"
%token TOK_SEMI_COLON ";"
%token TOK_ASSIGN ":="
%left TOK_ADD "+"
%left TOK_SUB "-"
%left TOK_MUL "*"
%left TOK_DIV "/"
%token<string> TOK_IDENTIFIER "identifier"
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
%token<number> TOK_NUMBER "number"

%type<node> code
%type<node> expression
%type<node> instruction
%type<node> identifier
%type<node> print
%type<node> read
%type<node> affectation
%type<node> number
%%
program: code;

code: code instruction |;

instruction: assign;

assign: identifier TOK_ASSIGN expression TOK_SEMI_COLON;

expression: identifier | number;

identifier: TOK_IDENTIFIER;

number: TOK_NUMBER;
%%

int yyerror(const char *msg) {
	fprintf(stderr, "Line %d: %s\n", yylineno, msg);
}

int main(int argc, char *argv[]) {
	if (argc != 2) {
		fprintf(stderr, "No input filename given\n");
		return EXIT_FAILURE;
	}

	char *file_name_input = argv[1];
	char *extension;
	char *directory_delimiter;
	char *basename;

	// file extension verification
	extension = rindex(file_name_input, '.');
	if (!extension || strcmp(extension, ".facile") != 0) {
		fprintf(stderr, "Input filename extension must be '.facile'\n");
		return EXIT_FAILURE;
	}

	// directory handling
	directory_delimiter = rindex(file_name_input, '/');
	if (!directory_delimiter) {
		directory_delimiter = rindex(file_name_input, '\\');
	}
	if (directory_delimiter) {
		basename = strdup(directory_delimiter + 1);
	} else {
		basename = strdup(file_name_input);
	}

	module_name = strdup(basename);
	*rindex(module_name, '.') = '\0';
	strcpy(rindex(basename, '.'), ".il");
	char *onechar = module_name;

	if (!isalpha(*onechar) && *onechar != '_') {
		free(basename);
		fprintf(stderr, "Base input filename must start with a letter or an underscore\n");
		return EXIT_FAILURE;
	}
	onechar++;
	while (*onechar) {
		if (!isalnum(*onechar) && *onechar != '_') {
			free(basename);
			fprintf(stderr, "Base input filename cannot contains special characters\n");
			return EXIT_FAILURE;
		}
		onechar++;
	}

	if (stdin = fopen(file_name_input, "r")) {
		if (stream = fopen(basename, "w")) {
			table = g_hash_table_new_full(g_str_hash, g_str_equal, free, NULL);
			yyparse();
			g_hash_table_destroy(table);
			fclose(stream);
			fclose(stdin);
		} else {
			free(basename);
			fclose(stdin);
			fprintf(stderr, "Output filename cannot be opened\n");
			return EXIT_FAILURE;
		}
	} else {
		free(basename);
		fprintf(stderr, "Input filename cannot be opened\n");
		return EXIT_FAILURE;
	}
	free(basename);
	return EXIT_SUCCESS;
}
