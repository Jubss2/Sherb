# Sherb
> Analisador léxico e sintático inspirado em The Sims.

O projeto consiste em desenvolver um compilador capaz de criar um código .c correspondente. A documentação pode ser encontrada [aqui](https://docs.google.com/document/d/1ktNytVNfwkZdrKOjaTMDoD7I5kAFVbOiF3WxN2hWH3o/edit?usp=sharing)

O projeto foi desenvolvido por: 
- [Júlia Furtado Araújo](https://github.com/Jubss2) - 2023005469
- [Larissa Maria Carvalho](https://github.com/LarissaMCarvalho) - 2020003531
- [Rafael Hadzic Rico de Sousa](https://github.com/RafaelHadzic) - 2020010302

## Instalação 

Para que o código seja devidamente compilado, é necessário que os seguintes programas estejam instalados na sua máquina:
- Bison 3.8.2 ou superior
- Flex 2.6.4 ou superior
- G++ 6.3.0 ou superior

## Execução

Para executar, os seguintes comandos devem ser inseridos no terminal:

Criando arquivos com o Bison:
```sh
bison -d sims.y
```
Criando arquivos com o Flex:
```sh
flex sims.l
```
Criando o arquivo .c
```sh
g++ lex.yy.c sintatico.tab.c -o compilador
```
