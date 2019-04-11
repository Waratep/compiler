%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
int symbols[255];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {long long int num; char id;}         /* Yacc definitions */
%start line
%token print println 
%token exit_command
%token <num> number string
%token <id> identifier
%type <num> line exp term 
%type <id> assignment


%%


line: assignment ';'		{}
    | exit_command ';'		{exit(EXIT_SUCCESS); }
    | println exp  ';'      {printf("%lld\n", $2);}
    | print exp ';'			{printf("%lld", $2);}
    | print string ';'      {printf("%s",(char * )($2));}
    | line print string ';' {printf("%s",(char * )($3));}
    | println string ';'    {printf("%s\n",(char * )($2));}
    | line assignment ';'	{}
    | line print exp ';'	{printf("%lld", $3);}
    | line println exp  ';' {printf("%lld\n", $3);}
    | line exit_command ';'	{exit(0);}
    ;

assignment: identifier '=' exp  { updateSymbolVal($1,$3); }
    ;

exp: term                  {$$ = $1;}
    | exp '+' exp          {$$ = $1 + $3;}
    | exp '-' exp          {$$ = $1 - $3;}
    | exp '*' exp          {$$ = $1 * $3;}
	| exp '/' exp			{
    if($3){
        $$ = $1 / $3;
	}else{
        $$ = $$;
        fprintf (stderr, "division by zero \n"  );
    }
    }	

	| exp '%' exp          {$$ = $1 % $3;}
	| '-' exp 				{$$ = - $2; }
    | '(' exp ')'			{$$ = $2;}
    ;

term: number                {$$ = $1;}
    | identifier			{$$ = symbolVal($1);} 
    ;

%%                     /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (int argc , char ** argv) {
	/* init symbol table */
	int i;
	for(i = 0 ; i < 255 ; i++) {  /*clear array value*/
		symbols[i] = 0;
	}
		
    extern int yylex();
    extern int yyparse();
    extern FILE * yyin;
    extern FILE *yyout;


	if(argc < 2){
		printf("Sawaddeeja. ni keu \" pasa karaoke\". version 1.0.0 by 0272 , 0823 , 0874 , 1189\n");
		return yyparse();
	}else{
        yyout = fopen(argv[2],"w");
        yyin = fopen(argv[1], "r");
        do{
    	    yyparse();         
        }while(!feof(yyin));
        fclose(yyout);
        fclose(yyin);
    }
	return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
