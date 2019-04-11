D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*


%{
#include "b.tab.h"
#include <string.h>
void yyerror (char *s);
int yylex();

void comment(int i); 

%}

%x STRING

%%

"print"			       {return print;}
"println"			   {return println;}
"bye"				   {return exit_command;}
{L}({L}|{D})*		   {yylval.id = yytext[0]; return identifier; }
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]                {};
[-+*/=;()%]            {return yytext[0];}

<INITIAL>\"            {BEGIN(STRING);}
<STRING>[^"]*\"        {BEGIN(INITIAL); yylval.num = strdup(yytext); return(string);}


"/*"	               { comment(1);}
"//"	               { comment(2);}

%%
int yywrap (void) {return 1;}


void comment(int i)
{
    int c;
    while((c = input()) != 0){
        if(i == 1){
            if(c == '*'){
                if((c = input()) == '/')
                    break;
                else
                    unput(c);
            }
        }else if(i == 2){
            if(c != 0){
                if((c = input()) == '\n')
                    break;
                else
                    unput(c);
            }
        }
    }
}

