//+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
//| UNIFAL − Universidade Federal de Alfenas .
//| BACHARELADO EM CIENCIA DA COMPUTACAO.
//| Trabalho . . : Vetor e verificacao de tipos
//| Disciplina : Teoria de Linguagens e Compiladores
//| Professor . : Luiz Eduardo da Silva
//| Aluno . . . . . : Hugo Jose Teodoro Terra
//| Data . . . . . . : 10/04/2022
//+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/
#define TAM_TAB 100
#define TAM_PIL 100

int Pilha[TAM_PIL];
int topo = -1;
int pos_tab = 0;
struct elem_tab_simbolos
{
    char id[100];
    int endereco;
    char tipo;
    char cat[5];
    int tam;
}TabSimb[TAM_TAB],elem_tab;

void empilha (int valor){
    if(topo == TAM_PIL)
        erro("Pilha Cheia");
    Pilha[++topo] = valor;
}

int desempilha (){
    if(topo == -1)
        erro("Pilha Vazia!");
    return Pilha [topo--]; 
}


int busca_simbolo(char *id){
    int i = pos_tab - 1;
    for(; strcmp(TabSimb[i].id,id) && i >=  0; i--)
      ;
    return i;
}

void insere_simbolo(struct elem_tab_simbolos elem){
    int i;
    if(pos_tab == TAM_TAB)
        erro("Tabela de Simbolos Cheia");
    i = busca_simbolo(elem.id);
    if( i != -1)
        erro("Identificador Duplicado");
    TabSimb[pos_tab++]= elem;

}
void mostra_tabela(){
    int i;
    puts("Tabela de Simbolos");
    printf("\n%3s  | %30s | %s | %s | %s | %s \n", "#", "ID", "END", "TIP", "CAT", "TAM");
    for(i=0;i < 65; i++)
        printf("-");
    for (i=0; i<pos_tab;i++)
        printf("\n%3d  | %30s | %3d | %3c | %3s | %3d\n",i,TabSimb[i].id,TabSimb[i].endereco,TabSimb[i].tipo, TabSimb[i].cat,TabSimb[i].tam);
    puts("\n");
}

void identificavetor (char *vet){
     elem_tab.endereco = elem_tab.endereco + elem_tab.tam; //soma do endereço com o tamanho
     elem_tab.tam = atoi(vet); //atoi utilizado para converter string em inteiro
}