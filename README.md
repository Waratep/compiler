# compiler
```
มีตัวแปร ทำ + - * / % ในวงเล็บได้ print string ได้
เหลือ array if-else และ loop

bison -d b.y
flex b.l
gcc b.tab.c lex.yy.c -o cc -lm
Run -> ./bb testL.oke

เพิ่มเงื่อนไข Generate ASM x64

./bb testL.oke asd.asm

```

```
// test.oke

print "test1  ";
println "test2";

println "Hello World!";

```


```
;  HELLO TEST Generate asm in bison/flex 
; Sawaddeeja. ni keu " pasa karaoke". version 1.0.0 by 0272 , 0823 , 0874 , 1189 

section .data
	msg0 db "test1  ",10
	msg1 db "test2",10
	msg2 db "Hello World!",10
section .text
	global _start

_start:

	mov rax, 1
	mov rdi, 1
	mov rsi, msg0
	mov rdx, 7
	syscall
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, 6
	syscall
	mov rax, 1
	mov rdi, 1
	mov rsi, msg2
	mov rdx, 13
	syscall
	mov rax, 60
	mov rdi, 0
	syscall


```
```
run asmx64 in nasm
nasm -f elf64 -o test.o test.asm
ld -o test test.o
./test
```
