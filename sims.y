%{
/* analisador sintático */
#include <iostream>
#include <string>
#include <string.h>
#include <fstream>
#include <map>

using namespace std;

enum Tipo { TIPO_INT, TIPO_FLOAT, TIPO_CHAR };

map<string, Tipo> variaveis;
string codigo = "";

/* protótipos das funções */
int yylex(void);
int yyparse(void);
void yyerror(const char *);

%}

%union {
	char var[256];
}

%token SULSUL DAGDAG FIRBS PABA KOOJ WOOBLE LOOBLE JUUN ENDCOMMA 
%token EQ NEQ GT LT
%token <var> INTEIRO
%token <var> REAL
%token <var> CARACTERE
%token <var> VAR

%type <var> BLOCO 
%type <var> COMANDOS 
%type <var> COMANDO 
%type <var> EXPR 
%type <var> DECLARACAO 
%type <var> ATRIB 
%type <var> SAIDA 
%type <var> LOGICA
%type <var> VALOR
%type <var> EXPR_RELAC
%type <var> IF_COMANDO

%left '+' '-'
%left '*' '/'
%left OR
%left AND
%left NOT

%start program

%%

program:  SULSUL BLOCO DAGDAG 
	{
		codigo = "#include<stdio.h>\n";		
		codigo += "#include<stdlib.h>\n";		
		codigo += "int main () {\n";
		codigo += $2;
		codigo += "\treturn 0;\n";
		codigo += "}";
	}
	;

BLOCO: '{' COMANDOS '}' 
		{ 
			strncpy($$, $2, 256);
		} 
	;

COMANDOS: 	COMANDOS COMANDO 
			{
				strcat($$, $2);
			}
			| COMANDO
			{
				
			}
    ;

COMANDO: DECLARACAO 
		| ATRIB 
		| SAIDA 
		| IF_COMANDO
	;

DECLARACAO: PABA VAR '=' EXPR ENDCOMMA  
			{ 
				strcpy($$, "\tfloat ");
				strcat($$, $2);
				strcat($$, " = ");
				strcat($$, $4);
				strcat($$, ";\n");
				variaveis[$2] = Tipo::TIPO_FLOAT;
				printf("\nATRIBUICAO");
			}
			| PABA VAR ENDCOMMA   		   
			{ 
				strcpy($$, "\tfloat ");
				strcat($$, $2);
				strcat($$, ";\n");
				variaveis[$2] = Tipo::TIPO_FLOAT;
				printf("\nATRIBUICAO");
			}
			| FIRBS VAR '=' EXPR ENDCOMMA   
			{ 
				strcpy($$, "\tint ");
				strcat($$, $2);
				strcat($$, " = ");
				strcat($$, $4);
				strcat($$, ";\n");
				variaveis[$2] = Tipo::TIPO_INT;
				printf("\nATRIBUICAO");
			}
			| FIRBS VAR ENDCOMMA   		   
			{ 
				strcpy($$, "\tint ");
				strcat($$, $2);
				strcat($$, ";\n");
				variaveis[$2] = Tipo::TIPO_INT;
				printf("\nATRIBUICAO");
			}
			| KOOJ VAR '=' CARACTERE ENDCOMMA   
			{ 
				strcpy($$, "\tchar ");
				strcat($$, $2);
				strcat($$, " = ");
				char caractere[5] = "'";
				caractere[1] = $4[1];
				caractere[2] = '\'';
				strcat($$, caractere);
				strcat($$, ";\n");
				variaveis[$2] = Tipo::TIPO_CHAR;
				printf("\nATRIBUICAO");
			}
			| KOOJ VAR ENDCOMMA   		   
			{ 
				strcpy($$, "\tchar ");
				strcat($$, $2);
				strcat($$, ";\n");
				variaveis[$2] = Tipo::TIPO_CHAR;
				printf("\nATRIBUICAO");
			}
		;



EXPR: EXPR '+' EXPR				
	{
		strcpy($$, $1);
		strcat($$, " + ");
		strcat($$, $3);
		printf("\nSOMA");
	}
	| EXPR '-' EXPR
	{
		strcpy($$, $1);
		strcat($$, " - ");
		strcat($$, $3);
		printf("\nSUBTRACAO")
	}
	| EXPR '*' EXPR
	{
		strcpy($$, $1);
		strcat($$, " * ");
		strcat($$, $3);
		printf("\nMULTI")
	}
	| EXPR '/' EXPR
	{
		strcpy($$, $1);
		strcat($$, " / ");
		strcat($$, $3);
		printf("\nDIVISAO")
	}
	| '(' EXPR ')'
	{
		strcpy($$, "(");
		strcat($$, $2);
		strcat($$, ")");
	}
	| VAR					
	| REAL	 	
	| INTEIRO    
	;


ATRIB: VAR '=' EXPR ENDCOMMA 
	{
		strcpy($$, "\t");
		strcat($$, $1);
		strcat($$, " = ");
		strcat($$, $3);
		strcat($$, ";\n");
		printf("\nATRIBUICAO VAR");
	} 	
	| VAR '=' CARACTERE ENDCOMMA  	
	{ 
		strcpy($$, "\t");
		strcat($$, $1);
		strcat($$, " = ");
		char caractere[5] = "'";
		caractere[1] = $3[1];
		caractere[2] = '\'';
		strcat($$, caractere);
		strcat($$, ";\n");
		printf("\nATRIBUICAO VAR");
	}
	; 

SAIDA:  JUUN '(' VAR ')' ENDCOMMA  
		{
			if(variaveis[$3] == Tipo::TIPO_INT){
				strcpy($$, "\tprintf(\"\%d\",");
			}else if(variaveis[$3] == Tipo::TIPO_FLOAT){
				strcpy($$, "\tprintf(\"\%f\",");
			}else{
				strcpy($$, "\tprintf(\"\%c\",");
			}
				strcat($$, $3);
				strcat($$, ");\n");
				printf("\nIMPRIMIR");
		}
		| JUUN '(' INTEIRO ')' ENDCOMMA   	
		{ 
			strcpy($$, "\tprintf(\"\%d\",");
			strcat($$, $3);
			strcat($$, ");\n"); 
			printf("\nIMPRIMIR");
		}
		| JUUN '(' REAL ')' ENDCOMMA 
		{
			strcpy($$, "\tprintf(\"\%f\",");
			strcat($$, $3);
			strcat($$, ");\n");
			printf("\nIMPRIMIR");
		}
		| JUUN '(' CARACTERE ')' ENDCOMMA 
		{
			strcpy($$, "\tprintf(\"\%c\",");
			char caractere[5] = "'";
			caractere[1] = $3[1];
			caractere[2] = '\'';
			strcat($$, caractere);
			strcat($$, ");\n");
			printf("\nIMPRIMIR");
		}
		;

LOGICA: NOT LOGICA 			
		{ 
			strcpy($$, "!");
			strcat($$, $2);
			printf("\nLOGICA");
		}
      	| LOGICA AND LOGICA   
	  	{
			strcpy($$, $1);
			strcat($$, "&&");
			strcat($$, $3);
			printf("\nLOGICA");
	  	}
      	| LOGICA OR LOGICA    
	  	{ 
			strcpy($$, $1);
			strcat($$, "||");
			strcat($$, $3);
			printf("\nLOGICA");
	  	}
      	| '(' LOGICA ')'  	
	  	{
			strcpy($$, "(");
			strcat($$, $2);
			strcat($$, ")");
			printf("\nLOGICA");
	  	}
	  	| EXPR_RELAC
	  	| VALOR 
      	;

VALOR: 	VAR | INTEIRO | REAL 
		;

EXPR_RELAC: VALOR EQ VALOR   
			{ 
				strcpy($$, $1);
				strcat($$, "==");
				strcat($$, $3);
				printf("\nEXPRESSAO RELACIONAL");
			}
			| VALOR NEQ VALOR
			{ 
				strcpy($$, $1);
				strcat($$, "!=");
				strcat($$, $3);
				printf("\nEXPRESSAO RELACIONAL");
			}
			| VALOR GT VALOR
			{ 
				strcpy($$, $1);
				strcat($$, ">");
				strcat($$, $3);
				printf("\nEXPRESSAO RELACIONAL");
			}
			| VALOR LT VALOR
			{ 
				strcpy($$, $1);
				strcat($$, "<");
				strcat($$, $3);
				printf("\nEXPRESSAO RELACIONAL");
			}
			;

IF_COMANDO: LOOBLE '(' LOGICA ')' BLOCO WOOBLE BLOCO
			{
				printf("\nCOMANDO CONDICIONAL");
				strcpy($$, "\tif(");
				strcat($$, $3);
				strcat($$, "){\n");
				strcat($$, $5);
				strcat($$, "}else{\n");
				strcat($$, $7);
				strcat($$, "}\n");
				
			}
			| LOOBLE '(' LOGICA ')' BLOCO
			{ 
				strcpy($$, "\tif(");
				strcat($$, $3);
				strcat($$, "){\n");
				strcat($$, $5);
				strcat($$, "}\n");
				printf("\nCOMANDO CONDICIONAL");
			}
		;

%%

/* definido pelo analisador léxico */
extern FILE * yyin;  

int main(int argc, char ** argv)
{
	/* se foi passado um nome de arquivo */
	if (argc > 1)
	{
		FILE * file;
		file = fopen(argv[1], "r");
		if (!file)
		{
			cout << "Arquivo " << argv[1] << " nao encontrado!\n";
			exit(1);
		}
		
		/* entrada ajustada para ler do arquivo */
		yyin = file;
	}

	yyparse();

	ofstream output("output.c");
	if (output.is_open()) {
        // Inserir codigo no arquivo
        output << codigo << endl;

        // Fechar o arquivo
        output.close();
    }
}

void yyerror(const char * s)
{
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   
	
	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro (" << s << "): simbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
	exit(1);
}
