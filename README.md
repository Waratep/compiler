# compiler
มีตัวแปร ทำ + - * / % ในวงเล็บได้
เหลือ array if-else และ loop\n\n

bison -d b.y\n
flex b.l\n
gcc b.tab.c lex.yy.c -o cc -lm\n
Run -> ./bb test_file\n
