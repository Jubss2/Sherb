/* Definicao da Linguagem */
%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>

#include "linguagem.h"
#include "var_aleatorio.h"
#include "lista_var.h"

/* prototipo */

void yyerror(char *s);
void imprima(No *root);

int yylex();

FILE *entrada, *saida;

No *root;
char *var_nome;   

%}

%union{
  No *pont;
}

/* Tipos de tokens */
%token <pont> ID
%token <pont> NUMINTEIRO
%token <pont> NUMREAL
%token <pont> EOL

%token <pont> FIRBS
%token <pont> PABA
%token <pont> KOOJ
%token <pont> FRO
%token <pont> LOOBLE
%token <pont> WOOBLE

%token <pont> OPEN_BRACE 
%token <pont> SULSUL
%token <pont> CLOSE_BRACE
%token <pont> OPEN_BLOCK
%token <pont> CLOSE_BLOCK

%token <pont> COMMA

%token <pont> EQ /* == */ 
%token <pont> GQ /* > */
%token <pont> NE

%type <pont> programa
%type <pont> lista_comando
%type <pont> bloco
%type <pont> ident
%type <pont> atribuicao
%type <pont> comparacao
%type <pont> comando
%type <pont> exp
%type <pont> soma
%type <pont> subtracao
%type <pont> divisao
%type <pont> multiplicacao
%type <pont> if_comando
%type <pont> igualdade
%type <pont> diferenca
%right 'fro'
%right '='
%left  '-' '+'
%left  '*' '/'
%left  '%'

/* Declaracao BISON - regras de gramatica */
%%

programa: lista_comando { root = $1; printf("root\n");} 

lista_comando: comando EOL lista_comando { $1->prox = $3; printf("lista_comanda\n");
	                                         $$ = $1;
	                                       }
              |comando EOL { $1->prox = 0; printf("lista_comando\n");
                                   $$ = $1;
                                 }                    
              |if_comando lista_comando{ $1->prox = $2; printf("lista_comanda\n");
	                                         $$ = $1;
	                                       }
              |if_comando{ $1->prox = 0; printf("lista_comanda\n");
	                                         $$ = $1;
	                                       }                                         


bloco: OPEN_BLOCK lista_comando CLOSE_BLOCK { $$ = $2; printf("bloco\n"); } 

ident: ID        { $$ = (No*)malloc(sizeof(No)); printf("ident\n");
          $$->token = ID;
		      strcpy($$->nome, yylval.pont->nome);
		      $$->esq = NULL;
		      $$->dir = NULL;
          $$->prox = NULL;
                    }  

exp: NUMREAL { $$ = (No*)malloc(sizeof(No)); printf("exp\n");
      $$->token = NUMREAL;
      $$->rval = $1->rval;
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    | NUMINTEIRO { $$ = (No*)malloc(sizeof(No)); printf("exp\n");
      $$->token = NUMINTEIRO;
      $$->ival = $1->ival;
      $$->esq = NULL;
      $$->dir = NULL;
      $$->prox = NULL;
    }
    
    | ident {printf("exp\n");}
    | soma {printf("soma\n");}
    | subtracao {printf("sub\n");}
    | divisao {printf("/\n");}
    | multiplicacao {printf("*\n");}
    ;

atribuicao: PABA ident '=' exp { $$ = (No*)malloc(sizeof(No)); printf("atribuicao\n");
			    $$->token = '=';
          $$->type = PABA;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | FIRBS ident '=' exp { $$ = (No*)malloc(sizeof(No)); printf("atribuicao\n");
			    $$->token = '=';
          $$->type = FIRBS;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          | KOOJ ident '=' exp { $$ = (No*)malloc(sizeof(No)); printf("atribuicao\n");
			    $$->token = '=';
          $$->type = KOOJ;
			    $$->esq = $2;
			    $$->dir = $4;
          $$->prox = NULL;
                          }
          ;

comando: atribuicao {printf("comando\n");}
        | bloco {printf("comando\n");}
        | if_comando {printf("comando\n");}
;

comparacao: igualdade {printf("comparacao\n");}
          | diferenca {printf("comparacao\n");}
;

soma: exp '+' exp { 
          $$ = (No*)malloc(sizeof(No)); printf("soma");
          $$->token = '+';
			                    $$->esq = $1;
			                    $$->dir = $3;
          $$->prox = NULL;
      }

subtracao: exp '-' exp { 
          $$ = (No*)malloc(sizeof(No));
          $$->token = '-';
			                      $$->esq = $1;
			                      $$->dir = $3;
          $$->prox = NULL;
      }

divisao: exp '/' exp { $$ = (No*)malloc(sizeof(No));
          $$->token = '/';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

multiplicacao: exp '*' exp { $$ = (No*)malloc(sizeof(No));
          $$->token = '*';
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
      }

igualdade: exp EQ exp     { $$ = (No*)malloc(sizeof(No)); printf("igualdade\n");
          $$->token = EQ;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }

diferenca: exp NE exp     { $$ = (No*)malloc(sizeof(No)); printf("diferenca\n");
                            $$->token = NE;
			    $$->esq = $1;
			    $$->dir = $3;
          $$->prox = NULL;
                          }
if_comando: LOOBLE OPEN_BRACE comparacao CLOSE_BRACE bloco
                { $$ = (No*)malloc(sizeof(No)); printf("IF\n");
		             $$->token = LOOBLE;
		             $$->lookahead = $3;
		             $$->esq = $5;
		             $$->dir = NULL;
      $$->prox = NULL;
                }
           | LOOBLE OPEN_BRACE comparacao CLOSE_BRACE bloco WOOBLE bloco
                { $$ = (No*)malloc(sizeof(No)); printf("if else\n");
		              $$->token = LOOBLE;
		              $$->lookahead = $3;
		              $$->esq = $5;
		              $$->dir = $7;
      $$->prox = NULL;
                }
           ;


%%

void yyerror(char *s) {
  printf("%s\n", s);
}

void imprima(No *root){
  printf("token: %d\n", root->token);
  if(root == NULL){
    printf("null\n");
  }
  if (root != NULL){
    
    switch(root->token){
      case NUMREAL:
        fprintf(saida,"%g", root->rval);
        break;
      
      case NUMINTEIRO:
        fprintf(saida,"%d", root->ival);
        break;

      case ID:
        fprintf(saida,"%s", root->nome);
        printf("%s", root->nome);
        break;

      case '=':
        if (insere_var(root->esq->nome) == 0){
          if(root->type==FIRBS){fprintf(saida,"int ");}
          if(root->type==PABA){fprintf(saida,"double ");}
          if(root->type==KOOJ){fprintf(saida,"char* ");}
        }
        imprima(root->esq);
        fprintf(saida,"=");
        imprima(root->dir);
        fprintf(saida,";\n");
        break;

      case '+':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"+");
        imprima(root->dir);
        break;

      case '-':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"-");
        imprima(root->dir);
        break;

      case '*':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"*");
        imprima(root->dir);
        break;  

      case '/':
        printf("%d", root->token);
        imprima(root->esq);
        fprintf(saida,"/");
        imprima(root->dir);
        break;  
      case EQ:
        imprima(root->esq);
        fprintf(saida,"==");
        imprima(root->dir);
        break;

      case NE:
        imprima(root->esq);
        fprintf(saida,"!=");
        imprima(root->dir);
        break;  
      case LOOBLE:
        printf("IF\n");
        fprintf(saida," \nif ");
        fprintf(saida,"(");
        imprima(root->lookahead);
        fprintf(saida,")");
        fprintf(saida,"  \n"); printf("aquiiii\n");
        imprima(root->esq);
        fprintf(saida," ");
        
        if(root->dir != NULL){
        fprintf(saida,"\n else");
        fprintf(saida," \n");
        imprima(root->dir);
        fprintf(saida," \n");
        }
        else fprintf(saida,"\n");
        break;
        
    
    default: 
      fprintf(saida,"Desconhecido ! Token = %d (%c) \n", root->token, root->token);
    }
    
    if (root->prox != NULL) {
      printf("aqui\n");
      imprima(root->prox);
    }
    return;
  }
}

int main(int argc, char *argv[]){
  
  char buffer[256];

  extern FILE *yyin;

  yylval.pont = (No*)malloc(sizeof(No));

  if (argc < 2){
    printf("Ops! Voce fez alguma coisa errada!\n");
    exit(1);
  }
  
  entrada = fopen(argv[1],"r");
  if(!entrada){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyin = entrada;

  strcpy(buffer,argv[1]);
  strcat(buffer,".cc");
  
  saida = fopen(buffer,"w");
  if(!saida){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyparse();

  fprintf(saida,"#include<iostream>\n");
  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");
  fprintf(saida,"\nint main(int argc, char *argv[]){\n");
  cria_lista();
  imprima(root);
  fprintf(saida,"\n}\n");

  fclose(entrada);
  fclose(saida);
}
