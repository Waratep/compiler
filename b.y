%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

void print_data();
void print_test();
void print_start();
void print_call(long long int x);
void print_bss();
void print_add();
void print_mod();
void print_div();
void print_negative();
void print_sub();
void print_int(int newline);
void print_after_print_int(int newline);
void print_newline();
void print_exit();
void print_string(char str[],int i,int len,int line);

extern FILE * yyout;

int var_counter = 0 , print_int_counter = 0, print_string_counter = 0, i = 0;
int value_of_var[255];
struct str{
    char str[255];
    int strlen;
    int type;
};

struct intt{
    long long int var;
    int type;
    char name;
};

struct symbol{
	char *name;
	long long int value;
	int type;
};

struct symbol sym[255];
struct str sstr[255];
struct intt intt[255];

%}

%union {
	long long int num; char *id;
}

%start line
%token print println 
%token exit_command
%token <num> number string
%token <id> identifier
%type <num> line exp term 
%type <id> assignment

%%

line: assignment ';'		  		{ }
    | exit_command ';'		  	{ exit(EXIT_SUCCESS); }
    | println exp  ';'        { intt[print_int_counter].var = $2; intt[print_int_counter].type = 1; print_int_counter++;}
    | print exp ';'			  		{ printf("%d",$2); intt[print_int_counter].var = $2; intt[print_int_counter].type = 0; print_int_counter++;}
    | print string ';'        { strcpy(sstr[print_string_counter].str,$2); sstr[print_string_counter].strlen = strlen($2); sstr[print_string_counter].type = 0; print_string_counter++;}
    | line print string ';'   { strcpy(sstr[print_string_counter].str,$3); sstr[print_string_counter].strlen = strlen($3); sstr[print_string_counter].type = 0; print_string_counter++;}
    | line println string ';' { strcpy(sstr[print_string_counter].str,$3); sstr[print_string_counter].strlen = strlen($3); sstr[print_string_counter].type = 1; print_string_counter++; }
    | println string ';'      { strcpy(sstr[print_string_counter].str,$2); sstr[print_string_counter].strlen = strlen($2); sstr[print_string_counter].type = 1; print_string_counter++;}
    | line assignment ';'	  	{ }
    | line print exp ';'	  	{ printf("%d",$3); intt[print_int_counter].var = $3; intt[print_int_counter].type = 0; print_int_counter++;}
    | line println exp  ';'   { intt[print_int_counter].var = $3; intt[print_int_counter].type = 1; print_int_counter++;}
    | line exit_command ';'	  { exit(0);}
    ;

assignment: identifier '=' exp  { sym[var_counter].name = $1; char *ptr = $1; while(*ptr != '\0') {printf("%c", *ptr); ptr++;} sym[var_counter].value = $3;  var_counter++; }
    ;

exp: term                  {$$ = $1;}
    | exp '+' exp          {$$ = $1 + $3;}
    | exp '-' exp          {$$ = $1 - $3;}
    | exp '*' exp          {$$ = $1 * $3;}
	| exp '/' exp		   {
    if($3){
        $$ = $1 / $3;
	}else{
        $$ = $$;
        fprintf (stderr, "division by zero \n"  );
    }
    }	

		| exp '%' exp           {$$ = $1 % $3;}
		| '-' exp 							{$$ = - $2;}
    | '(' exp ')'						{$$ = $2;}
    ;

term: number                {$$ = $1;}
    | identifier						{$$ = sym[var_counter-1].value;} 
    ;

%%                     /* C code */



void print_data(){

    fprintf(yyout,"section .data\n");
    fprintf(yyout,"\tdatabuffer: db  0000h\n");
    for(int i = 0 ; i < var_counter ; i++){
        fprintf(yyout,"\tdata%d:  db  %.4xh\n",i,intt[i].var);
    }
}

void print_test(){
    fprintf(yyout,"section .text\n");
    fprintf(yyout,"\tglobal _start\n\n");

}

void print_start(){
    fprintf(yyout,"_start:\n\n"); 

}

void print_add(){
    fprintf(yyout,"\tpop    bx\n"); 
    fprintf(yyout,"\tpop    dx\n"); 
    fprintf(yyout,"\tmov    bx , %xh\n",value_of_var[0]); 
    fprintf(yyout,"\tmov    dx , %xh\n",value_of_var[1]); 
    fprintf(yyout,"\tadd    bx , dx\n"); 
    fprintf(yyout,"\tmov    databuffer , bx\n"); 
    fprintf(yyout,"\tpush   bx\n"); 
    fprintf(yyout,"\tpush   dx\n"); 
}

void print_sub(){

}

void print_mul(){

    fprintf(yyout,"\tpop    bx\n"); 
    fprintf(yyout,"\tpop    dx\n"); 
    fprintf(yyout,"\tmov    bx , %xh\n",value_of_var[0]); 
    fprintf(yyout,"\tmov    dx , %xh\n",value_of_var[1]); 
    fprintf(yyout,"\tmul    bx , dx\n"); 
    fprintf(yyout,"\tmov    databuffer , bx\n"); 
    fprintf(yyout,"\tpush   bx\n"); 
    fprintf(yyout,"\tpush   dx\n"); 
}

void print_div(){

}

void print_mod(){

}

void print_negative(){

}

void print_char_to_int(){

}

void print_exit(){
    fprintf(yyout,"exit:\n");
    fprintf(yyout,"\tmov rax, 60\n");
    fprintf(yyout,"\tmov rdi, 0\n");
    fprintf(yyout,"\tsyscall\n");
}

void print_newline(){
    fprintf(yyout,"\tmov rax, 1\n");
    fprintf(yyout,"\tmov rdi, 1\n");
    fprintf(yyout,"\tmov rsi, 0xa\n");
    fprintf(yyout,"\tmov rdx, 1\n");
    fprintf(yyout,"\tsyscall\n");
}

void print_string(char str[],int i,int len, int line){

    fprintf(yyout,"\tmov rax, 1\n");
    fprintf(yyout,"\tmov rdi, 1\n");
    fprintf(yyout,"\tmov rsi, %s%d\n",str,i);
    if(line){
        fprintf(yyout,"\tmov rdx, %d\n",len+1);
    }else{
        fprintf(yyout,"\tmov rdx, %d\n",len);
    }
    fprintf(yyout,"\tsyscall\n");
    

}

void print_call(long long int x){
    fprintf(yyout,"\tmov rax, %lld\n",x);
    fprintf(yyout,"\tcall _printRAX\n");

}

void print_int(int newline){

    fprintf(yyout,"int_to_str:\n");
    fprintf(yyout,"\tmov rdx, 0\n");
    fprintf(yyout,"\tmov rbx, 10\n");
    fprintf(yyout,"\tdiv rbx\n");
    fprintf(yyout,"\tadd rdx, 48\n");
    fprintf(yyout,"\tadd rdx, 0x0\n");
    fprintf(yyout,"\tpush rdx\n");
    fprintf(yyout,"\tinc r12\n");
    fprintf(yyout,"\tcmp rax, 0x0\n");
    fprintf(yyout,"\tjne int_to_str\n");
    fprintf(yyout,"\tjmp print\n");

    print_after_print_int(newline);
}

void print_after_print_int(int newline){
    fprintf(yyout,"print:\n");        
    fprintf(yyout,"\tmov rax, 1\n");        
    fprintf(yyout,"\tmul r12\n");        
    fprintf(yyout,"\tmov r12, 8\n");        
    fprintf(yyout,"\tmul r12\n");        
    fprintf(yyout,"\tmov rdx, rax\n");        
    fprintf(yyout,"\tmov rax, 1\n");        
    fprintf(yyout,"\tmov rdi, 1\n");        
    fprintf(yyout,"\tmov rsi, rsp\n");        
    fprintf(yyout,"\tprint:\n");        
    fprintf(yyout,"\tsyscall\n");

    if(newline){
        print_newline();
    }        
    
}

int main (int argc , char ** argv) {
	/* init symbol table */
	for(int i = 0 ; i < 255 ; i++) {  /*clear array value*/
        value_of_var[i] = 0;
	}
		
    extern int yylex();
    extern int yyparse();
    extern FILE * yyin;

	if(argc < 2){
		printf("Sawaddeeja. ni keu \" pasa karaoke\". version 1.0.0 by 0272 , 0823 , 0874 , 1189\n");
		return yyparse();
	}else{
        yyin = fopen(argv[1], "r");

        for(i = 0 ; i < 1 ; i++){
            do{
    	        yyparse();
            }while(!feof(yyin));
        }

        yyout = fopen(argv[2], "w");

        if(var_counter != 0){
            fprintf(yyout, ";  HELLO TEST Generate asm in bison/flex \n");
            fprintf(yyout, "; Sawaddeeja. ni keu \" pasa karaoke\". version 1.0.0 by 0272 , 0823 , 0874 , 1189 \n\n"); 
            print_data();
            if(print_string_counter > 0){
                for(int i = 0 ; i < print_string_counter; i++){
                    fprintf(yyout,"\tmsg%d db \"%s\"\n",i,sstr[i].str);
                }            
            }
            print_test(); 
            print_start();
            if(var_counter > 0){
                for(int i = 0 ; i < print_int_counter; i++){
                    if(intt[0].type){
                        print_int(1);
                    }else{
                        print_int(0);
                    }
                    // fprintf(yyout,"\n\n\n%s  =  %d\n",intt[var_counter].name,intt[var_counter].var);
                }        
            }
            if(print_string_counter > 0){
                for(int i = 0 ; i < print_string_counter; i++){
                    print_string("msg",i,sstr[i].strlen,0);
                }                    
            }            
        }else if(i > 0){
            fprintf(yyout, ";  HELLO TEST Generate asm in bison/flex \n");
            fprintf(yyout, "; Sawaddeeja. ni keu \" pasa karaoke\". version 1.0.0 by 0272 , 0823 , 0874 , 1189 \n\n"); 
            fprintf(yyout,"section .data\n");
            if(print_string_counter > 0){            
                for(int i = 0 ; i < print_string_counter; i++){
                    fprintf(yyout,"\tmsg%d db \"%s\",10\n",i,sstr[i].str);
                }    
            }
            print_test(); 
            print_start();
            if(print_int_counter > 0){
                for(int i = 0 ; i < print_int_counter; i++){
                    if(intt[0].type){
                        print_int(1);
                    }else{
                        print_int(0);
                    }
                }    
            }
            if(print_string_counter > 0){
                for(int i = 0 ; i < print_string_counter; i++){
                    if(sstr[i].type){
                        print_string("msg",i,sstr[i].strlen,1);
                    }else{
                        print_string("msg",i,sstr[i].strlen,0);
                    }
                }                    
            }

        }

        for(int i = 0; i < var_counter; i++){

            printf("%s = %d\n",sym[i].name,sym[i].value);
        }
        print_exit();

        fclose(yyin);
        fclose(yyout);

    }
	return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
