#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

#include "var_aleatorio.h"

char *nome(){
  static int n=0;
  char *variavel;

  variavel = (char*)malloc(9);
  if (variavel == NULL){
    printf("Erro !! \n");
  }
  sprintf(variavel, "tmp%05d", n);
  n++;
  return variavel;
 
}


