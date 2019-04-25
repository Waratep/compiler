D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS	  (f|F|l|L)
IS		(u|U|l|L)*


%option noyywrap nodefault yylineno

%{
#include "main.h"
#include "parsing.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <string.h>

static int64_t strToHex(char* s);
extern int errorflag;
%}

%%

[ \t]              {  }
[0-9]+[dD]         { yylval.num = (int64_t)atoi(yytext); return (NUM); }
[0-9a-fA-F]+[hH]   { yylval.num = strToHex(yytext); return (NUM);}
({L})|({L}{L})     { yylval.sym = lookup(yytext); return (VAR); }
["].*["]           { yylval.str = strdup(yytext); return (TEXT); }
"="                { return (TK_ASSIGN); }
"(" |
")" |
"{" |
"}" |
"+" |
"-" |
"*" |
"/" |
"%" |
"^" |
";" |
","                { return (yytext[0]); }
"sadangS"          { return (CMD_PS); }
"sadangH"          { return (CMD_PH); }
"sadangD"          { return (CMD_PD); }
"thaogun"          { return (TK_IFE); }
"maithaogun"       { return (TK_IFE); }
"makgua"           { return (TK_IFG);}
"noigua"           { return (TK_IFL);}
"thumsum"          { return (TK_LOOP); }
\n                 {  }
"/*"	             { comment(1);}
"//"	             { comment(2);}
.                  { errorflag = 1; yyerror("Mystery character %c\n", *yytext); }
%%

static int64_t strToHex(char* s) {
  int len = strlen(s);
  s[len-1] = 0;
  return (int64_t)( strtol(s, NULL, 16) );
}

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



