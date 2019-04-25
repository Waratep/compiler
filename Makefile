all: main run

main: main.c lexer.l parsing.y main.h asmgen.c asmgen.h
	bison -d parsing.y
	flex -o lexer.lex.c lexer.l
	gcc -Wall main.c parsing.tab.c lexer.lex.c asmgen.c -o $@ -g

clean:
	rm parsing.tab.c lexer.lex.c parsing.tab.h

run:
	./main test.oke
	gcc test.s -o test -ggdb
