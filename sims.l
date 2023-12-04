%{ 
/* analisador léxico para uma calculadora básica */ 
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "sims.tab.h"
%}

%option yylineno
%option noyywrap

digito	        [0-9]
letra 	        [a-zA-Z]
separador       "'"
underscore      "_"
inteiro         [-+]?{digito}+ 
real            [-+]?{digito}+"."{digito}+
caractere       {separador}[a-zA-Z0-9/" "]{separador}

var             {letra}({letra}|{digito}|{underscore})*

%%
";"          {return ENDCOMMA;}
"sulsul"     {return SULSUL;}
"dagdag"     {return DAGDAG;}
"firbs"      {printf("\nINT");return FIRBS; }
"paba"       {printf("\nFLOAT");return PABA; }
"kooj"       {printf("\nCHAR");return KOOJ; }
"wooble"     {printf("\nIF");return WOOBLE;}
"looble"     {printf("\nELSE");return LOOBLE;}  
"juun"       {return JUUN;}
[\t ]+		 { /* espaço em branco */ }
[\n]+        { /* quebras de linha */ }
"neeshga"    { return NOT; }
"zor"        { return AND; }
"mik"        { return OR; }
"=="         { return EQ; }
"!="         { return NEQ; }
">"          { return GT; }
"<"          { return LT; }
{inteiro}    { strcpy(yylval.var, yytext); return INTEIRO; }
{real}       { strcpy(yylval.var, yytext); return REAL; }
{caractere}  { strcpy(yylval.var, yytext); return CARACTERE; }
{var}	     { strcpy(yylval.var, yytext); return VAR; }

.            { return *yytext; }

%%