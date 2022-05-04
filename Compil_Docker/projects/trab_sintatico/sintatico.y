//+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
//| UNIFAL − Universidade Federal de Alfenas .
//| BACHARELADO EM CIENCIA DA COMPUTACAO.
//| Trabalho . . : Vetor e verificacao de tipos
//| Disciplina : Teoria de Linguagens e Compiladores
//| Professor . : Luiz Eduardo da Silva
//| Aluno . . . . . : Hugo Jose Teodoro Terra
//| Data . . . . . . : 10/04/2022
//+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/
%{

#include <stdio.h>
#include <stdlib.h>
#include "lexico.c"
#include <stdlib.h>
#include "estrut.c"
void erro (char *s);
int yyerror (char *s);
int conta = 0;
int tam ;
char var[3] = "VAR";
char vet[3] = "VET";
int rotulo = 0;
char tipo;

%}

%start programa

%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_IDENTIF
%token T_LEIA
%token T_ESCREVA
%token T_ENQTO
%token T_FACA
%token T_FIMENQTO
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ATRIB
%token T_VEZES
%token T_DIV
%token T_MAIS
%token T_MENOS
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_E
%token T_OU
%token T_V
%token T_F
%token T_NUMERO
%token T_NAO
%token T_ABRE
%token T_FECHA
%token T_ABREC
%token T_FECHAC
%token T_LOGICO
%token T_INTEIRO


%token T_REPITA
%token T_FIMREPITA
%token T_ATE

%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV
%%

programa : cabecalho variaveis
        {mostra_tabela();
        fprintf(yyout,"\tAMEM\t%d\n",conta);
        empilha(conta);
        }
     T_INICIO lista_comandos T_FIM
        {
        fprintf(yyout,"\tDMEM\t%d\n", conta);
        fprintf(yyout,"\tFIMP\n");
        }
     ;
cabecalho : T_PROGRAMA T_IDENTIF
    {fprintf(yyout,"\tINPP\n");}
;
variaveis : | declaracao_variaveis;
declaracao_variaveis : declaracao_variaveis tipo lista_variaveis 
                         |  tipo lista_variaveis; 
tipo : T_LOGICO { tipo='l';} | T_INTEIRO {tipo ='i';}
        ;
lista_variaveis :
        lista_variaveis variavel
        | variavel 
        ;
variavel : T_IDENTIF
    {
        strcpy(elem_tab.id, atomo);
    }
      tamanho
    | T_IDENTIF
    {
        strcpy(elem_tab.id, atomo);
    }
     T_ABREC T_NUMERO T_FECHAC tamanho
    ;
tamanho :
    {   
        elem_tab.tipo = tipo;
        strcpy(elem_tab.cat,"VAR");
        elem_tab.tam = 1;
        elem_tab.endereco = conta++ ;
        insere_simbolo(elem_tab);
    }
    | T_ABREC T_NUMERO
        {
        elem_tab.tipo= tipo;
        strcpy(elem_tab.cat,"VET");
        identificavetor(atomo);
        conta = elem_tab.tam + conta ;
        insere_simbolo(elem_tab);
        }
     T_FECHAC
    ;
lista_comandos : | comando lista_comandos;
comando : leitura | escrita | repeticao | selecao | atribuicao;
leitura : T_LEIA T_IDENTIF
    {
        int pos=busca_simbolo(atomo);
        if(pos == -1)
            erro("Variavel não declarada!");
        empilha(pos);
    }
    posicao;
posicao : 
    {
        int r = desempilha();
        fprintf(yyout,"\tLEIA\n");
        fprintf(yyout,"\tARZG\t%d\n",TabSimb[r].endereco);
    }
    | T_ABREC  expr 
    {
        char t1 = desempilha();
        int posi = desempilha();
        int pos=busca_simbolo(atomo);
        fprintf(yyout,"\tLEIA\n");
        fprintf(yyout,"\tARZV\t%d\n",TabSimb[posi].endereco);
    } 
     T_FECHAC
    ;
escrita :
    T_ESCREVA expr
    {
        desempilha();
        fprintf(yyout,"\tESCR\n");
    }
;
repeticao : T_ENQTO 
    {
        rotulo++;
        fprintf(yyout,"L%d\tNADA\n",rotulo);
        empilha(rotulo);
    }
expr T_FACA 
    {
        char t = desempilha();
        if( t!= 'l')
            erro("Incompatibilidade de Tipo");
        rotulo++;
        fprintf(yyout,"\tDSVF\tL%d\n",rotulo);
        empilha(rotulo);
    }
    lista_comandos T_FIMENQTO 
    {
        int r1 = desempilha();
        int r2 = desempilha();
        fprintf(yyout,"\tDSVS\tL%d\n",r2);
        fprintf(yyout,"L%d\tNADA\n",r1);
    }
    |
    T_REPITA
    {
        rotulo++;
        fprintf(yyout,"L%d\tNADA\n",rotulo);
        empilha(rotulo);
    }
    lista_comandos T_ATE  expr T_FIMREPITA 
    {
        char t = desempilha();
        if( t != 'l')
            erro("Incompatibilidade de Tipo");
        rotulo++;
        fprintf(yyout,"\tDSVF\tL%d\n",rotulo);
        int r20 = desempilha();
        fprintf(yyout,"\tDSVS\tL%d\n",r20);
        fprintf(yyout,"L%d\tNADA\n",rotulo);
    }
    ;
selecao : T_SE expr T_ENTAO 
    {
        char t = desempilha();
        if( t != 'l')
            erro("Incompatibilidade de Tipo");
        rotulo++;
        fprintf(yyout,"\tDSVF\tL%d\n",rotulo);
        empilha(rotulo);
    }
lista_comandos T_SENAO 
    {
        int r = desempilha ();
        rotulo++;
        fprintf(yyout,"\tDSVS\tL%d\n",rotulo);
        fprintf(yyout,"L%d\tNADA\n",r);
        empilha(rotulo);
    }
lista_comandos T_FIMSE
    {
        int r = desempilha(); 
        fprintf(yyout,"L%d\tNADA\n",r);
    }
    ;

atribuicao : T_IDENTIF 
    {  int pos=busca_simbolo(atomo);
        if(pos==-1)
            erro("Variavel não declarada!");
        empilha(pos);
    }
        T_ATRIB expr
    {
        char tip = desempilha();
        int posic = desempilha();
        if(tip != TabSimb[posic].tipo)
            erro("Incompatibilidade de Tipo");
        fprintf(yyout,"\tARZG\t%d\n",TabSimb[posic].endereco);
    }
    | T_IDENTIF 
    {   int pos=busca_simbolo(atomo);
        if(pos==-1)
            erro("Variavel não declarada!");
        empilha(pos);
    }
        
    testavetor  T_ATRIB expr
    {
        char t = desempilha();
        int p = desempilha();
        if(t != TabSimb[p].tipo)
            erro("Incompatibilidade de Tipo");
        fprintf(yyout,"\tARZV\t%d\n",TabSimb[p].endereco);
    }
    | T_IDENTIF 
    {   
        int pos=busca_simbolo(atomo);
            if(pos==-1)
                erro("Variavel não declarada!");
        empilha(pos);
    }
    testavetor T_NUMERO 
    {
        fprintf(yyout,"\tCRCT\t%s\n",atomo);
    }
    
    T_ATRIB expr
    {   char t = desempilha();
        int p = desempilha();
        if(t != TabSimb[p].tipo)
            erro("Incompatibilidade de Tipo");
        fprintf(yyout,"\tARZV\t%d\n",TabSimb[p].endereco);
    }     
;
testavetor :
    | T_ABREC expr{
        char t = desempilha();
        int p =desempilha();
        if(t == 'l')
            erro("Tipo do Indice deve ser Inteiro");
        empilha(p);
    }
    T_FECHAC
    ;
expr :  expr T_VEZES expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
        erro("Incompatibilidade de Tipos");
        empilha('i');
        fprintf(yyout,"\tMULT\n");
        
    }
    |
    expr T_DIV expr 
    {   
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
        erro("Incompatibilidade de Tipos");
        empilha('i');
        fprintf(yyout,"\tDIVI\n");
    }     
    |
    expr T_MAIS expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
            erro("Incompatibilidade de Tipos");
        empilha('i');
        fprintf(yyout,"\tSOMA\n");
    }
    |
    expr T_MENOS expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
            erro("Incompatibilidade de Tipos");
        empilha('i');
        fprintf(yyout,"\tSUBT\n");
    }
    |
    expr T_MAIOR expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
            erro("Incompatibilidade de Tipos");
        empilha('l');
        fprintf(yyout,"\tCMMA\n");
    }
    |   
    expr T_MENOR expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
            erro("Incompatibilidade de Tipos");
        empilha('l');
        fprintf(yyout,"\tCMME\n");
    }
    |
    expr T_IGUAL expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'i' || t2 != 'i')
            erro("Incompatibilidade de Tipos");
        empilha('l');
        fprintf(yyout,"\tCMIG\n");
    
    }
    |
    expr T_E expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'l' || t2 != 'l')
            erro("Incompatibilidade de Tipos");
        empilha('l');
        fprintf(yyout,"\tCONJ\n");
    }
    |
    expr T_OU expr 
    {
        char t1 = desempilha();
        char t2 = desempilha();
        if(t1 != 'l' || t2 != 'l')
            erro("Incompatibilidade de Tipos");
        empilha('l');
        fprintf(yyout,"\tDISJ\n");
    }
    |
    termo;
termo : T_IDENTIF 
    {
        int pos=busca_simbolo(atomo);
            if(pos==-1)
            erro("Variavel não declarada!");
        fprintf(yyout,"\tCRVG\t%d\n",TabSimb[pos].endereco);
        empilha(TabSimb[pos].tipo);
    }
    |
    T_NUMERO 
    {
        fprintf(yyout,"\tCRCT\t%s\n",atomo);
        empilha('i');
    }
    |
    T_V 
    {
        fprintf(yyout,"\tCRCT\t1\n");
        empilha('l');
    }
    |
    T_F 
    {
        fprintf(yyout,"\tCRCT\t0\n");
        empilha('l');
    }    
    |
    T_NAO termo 
    {
        char t = desempilha();   
        if(t != 'l')
            erro("Incompatibilidade de tipo");
        empilha('l');
        fprintf(yyout,"\tNEGA\n");
    }
    |T_IDENTIF {
    int pos=busca_simbolo(atomo);
            if(pos == -1)
        erro("Variavel não declarada!");
    empilha(pos);
    }
    T_ABREC expr 
    
    T_FECHAC    
    {
    char t1 = desempilha();
    int t2 = desempilha();
    fprintf(yyout,"\tCRVV\t%d\n",TabSimb[t2].endereco); 
    empilha(t1);
    }
    |  T_IDENTIF {
        
    int pos=busca_simbolo(atomo);
        if(pos == -1)
        erro("Variavel não declarada!");
    empilha(pos);
    } 
    T_ABREC T_NUMERO 
    {
    fprintf(yyout,"\tCRCT\t%s\n",atomo);
    }
    T_FECHAC
    {
    char t1 = desempilha();
    int t2 = desempilha();
    fprintf(yyout,"\tCRVV\t%d\n",TabSimb[t2].endereco); 
    empilha(t1);
    }
    |
    T_ABRE expr T_FECHA
    ;  


%%

void erro(char*s){
    printf("ERRO na Linha  %d :  %s\n",numLinha, s);
    exit(10);
}

int yyerror(char *s){
    erro(s);
}

int main(int argc, char *argv[]){
    char *p , nameIn[100], nameOut[100];
    argv++;
    if(argc < 2){
        puts("\nCompilador Simples");
        puts("\tUso: ./simples <nomefonte>[simples]\n\n");
        exit(10);
    }
    p=strstr(argv[0],".simples");
    if(p) *p=0;
    strcpy(nameIn,argv[0]);
    strcat(nameIn,".simples");
    strcpy(nameOut, argv[0]);
    strcat(nameOut,".mvs");

    yyin = fopen(nameIn,"rt");
    if(!yyin){
        puts("Programa Fonte não Reconhecido");
        exit(10);
    }
    yyout = fopen(nameOut,"wt");
    if(!yyparse())
        puts("Programa OK");
}