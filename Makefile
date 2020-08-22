
my : ast.tab.c lex.yy.c
	gcc -w -o my ast.tab.c lex.yy.c newhtml.c 

lex.yy.c: lex.l
	lex lex.l

ast.tab.h ast.tab.c: ast.y
	bison -d -t ast.y

