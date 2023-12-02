/* Insercao de nomes de variaveis na lista */

#include<stdio.h>
#include<math.h>
#include<string.h>
#include<stdlib.h>

#include "lista_var.h"

enum bool { false, true };

void cria_lista(){
  cabeca = 0;
}

int insere_var(char *var){
  ant = 0;

  aux = cabeca;

  while(aux && strcmp(aux->var,var) != 0){
    ant = aux;
    aux = aux->prox;
  }
  
  if ((ant == 0) && (aux == 0)){
    aux = (Lista_var *)malloc(sizeof(Lista_var));
    strncpy(aux->var, var, 32);
    aux->prox = cabeca;
    cabeca = aux;
    return 0;
  }
  else{
    if (aux == 0){
      aux = (Lista_var *)malloc(sizeof(Lista_var));
      strncpy(aux->var, var, 32);
      aux->prox = ant->prox;
      ant->prox = aux;
      return 0;
    }
    return 1;
  }
}

