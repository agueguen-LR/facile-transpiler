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
extern void begin_code();
extern void produce_code(GNode* node);
extern void end_code();

char* module_name;
FILE* stream;
GHashTable* table;

typedef enum {
	NODE_NULL,
	NODE_CODE,
	NODE_ASSIGN,
	NODE_ADD,
	NODE_SUB,
	NODE_MUL,
	NODE_DIV,
	NODE_NUMBER,
	NODE_IDENTIFIER,
	NODE_PRINT,
	NODE_READ
} NodeType;

// https://docs.gtk.org/glib/conversion-macros.html#type-conversion
GNode* make_node(NodeType type) {
	return g_node_new(GINT_TO_POINTER(type));
}
%}

%define parse.error verbose

%union {
	gulong number;
	gchar* string;
	GNode* node;
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
%type<node> assign
%type<node> number

%%
program: code {
	begin_code();
	produce_code($1);
	end_code();
	g_node_destroy($1);
};

code: code instruction {
	$$ = make_node(NODE_CODE);
	g_node_append($$, $1);
	g_node_append($$, $2);
} | %empty {
	$$ = make_node(NODE_NULL);
};

instruction: assign | print | read;

assign: identifier TOK_ASSIGN expression TOK_SEMI_COLON {
	$$ = make_node(NODE_ASSIGN);
	g_node_append($$, $1);
	g_node_append($$, $3);
};

print: TOK_PRINT expression TOK_SEMI_COLON {
	$$ = make_node(NODE_PRINT);
	g_node_append($$, $2);
};

read: TOK_READ identifier TOK_SEMI_COLON {
	$$ = make_node(NODE_READ);
	g_node_append($$, $2);
};

expression: identifier | number | expression TOK_ADD expression {
	$$ = make_node(NODE_ADD);
	g_node_append($$, $1);
	g_node_append($$, $3);
};

identifier: TOK_IDENTIFIER {
	$$ = make_node(NODE_IDENTIFIER);
	gulong value = (gulong) g_hash_table_lookup(table, $1);
	if (!value) {
		value = g_hash_table_size(table) + 1;
		g_hash_table_insert(table, strdup($1), (gpointer) value);
	}
	g_node_append_data($$, (gpointer)value);
};

number: TOK_NUMBER {
	$$ = make_node(NODE_NUMBER);
	g_node_append_data($$, (gpointer)$1);
};
%%

int yyerror(const char *msg) {
	fprintf(stderr, "Line %d: %s\n", yylineno, msg);
}

void begin_code(){
	fprintf(stream, ".assembly test {}\n");
	fprintf(stream, ".assembly extern mscorlib {}\n");
	fprintf(stream, ".method static void Main()\n{\n");
	fprintf(stream, "\t.entrypoint\n");
	fprintf(stream, "\t.maxstack 10\n");
	fprintf(stream, "\t.locals init (");
	if (g_hash_table_size(table) > 0) {
		fprintf(stream, "int32");
	}
	for (int i = 1; i < g_hash_table_size(table); i++){
		fprintf(stream, ", int32");
	}
	fprintf(stream, ")\n");
}

void end_code(){
	fprintf(stream, "\tret\n");
	fprintf(stream, "}");
}

void produce_code(GNode* node) {
	switch ((NodeType)GPOINTER_TO_INT(node->data)) {

		case NODE_CODE:
			produce_code(g_node_nth_child(node, 0));
			produce_code(g_node_nth_child(node, 1));
			break;

		case NODE_ASSIGN:
			produce_code(g_node_nth_child(node, 1));
			fprintf(stream, "\tstloc\t%ld\n", (long)g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1);
			break;

		case NODE_ADD:
			produce_code(g_node_nth_child(node, 0));
			produce_code(g_node_nth_child(node, 1));
			fprintf(stream, "\tadd\n");
			break;

		case NODE_SUB:
			produce_code(g_node_nth_child(node, 0));
			produce_code(g_node_nth_child(node, 1));
			fprintf(stream, "\tsub\n");
			break;

		case NODE_NUMBER:
			fprintf(stream, "\tldc.i4\t%ld\n", (long)g_node_nth_child(node, 0)->data);
			break;

		case NODE_IDENTIFIER:
			fprintf(stream, "\tldloc\t%ld\n", (long)g_node_nth_child(node, 0)->data - 1);
			break;

		case NODE_PRINT:
			produce_code(g_node_nth_child(node, 0));
			fprintf(stream, "\tcall void class [mscorlib]System.Console::WriteLine(int32)\n");
			break;

		case NODE_READ:
			fprintf(stream, "\tcall string class [mscorlib]System.Console::ReadLine()\n");
			fprintf(stream, "\tcall int32 int32::Parse(string)\n");
			fprintf(stream, "\tstloc\t%ld\n", (long)g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1);
			break;

	}
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

	//filename verification
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

	//Open I/O streams and begin parsing
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
