# compiler
มีตัวแปร ทำ + - * / % ในวงเล็บได้ print string ได้
เหลือ array if-else และ loop

bison -d b.y
flex b.l
gcc b.tab.c lex.yy.c -o cc -lm
Run -> ./bb test_file
