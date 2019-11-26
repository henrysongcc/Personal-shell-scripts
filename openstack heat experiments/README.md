## Resumo

Este projeto consiste em fornecer uma maneira, ou uma ferramenta, para realizar testes de capacidade para a estrutura de cloud. 

Existe um script, chamado cloud-benchmarkPairs.sh , que dispara uma quantidade de pares de instâncias, bem como o tipo de teste (iperf ou mtr) a ser determinado pelo usuário, em ciclos de 1 minuto, por cada teste. Ao final deste, é gerada uma saída típica da aplicação correspondente ao teste escolhido, a fim de ser interpretada pelo usuário, a depender da estrutura e das condições/recursos alocados do ambiente de computação na nuvem em questão.
Na versão atual, o script e as instâncias que estão em execução fazem verificações periódicas em um servidor web, executado em uma instância separada, e verificam o estado dele para executar uma determinada tarefa, como disparar um novo par, ou executar uma nova iteração do teste especificado pelo usuário.

## Exemplo de uso

A ideia é que o usuário determine a quantidade de pares e o tipo de teste que serão passados neste.

Assim, se você chama o script como:

$ ./cloud-benchmarkPairs.sh mtr 3 flavor.servidor flavor.cliente

Seu teste será com a aplicação mtr, e terá ciclos do tipo:

1 - um par de instâncias, executando um teste do mtr durante um minuto.

2 - dois pares de instâncias, com o primeiro par executando um novo teste do mtr durante um minuto, e um novo par executando um teste do mtr durante um minuto.

3 - três pares de instâncias, com os dois primeiros pares executando seus testes novamente durante um minuto, e um novo, terceiro par, executando um teste do mtr durante um minuto.

E serão usados os flavors "flavor.servidor" da instância onde será executado o servidor de cada par, e "flavor.cliente" o flavor da instância onde será executado o cliente de cada par.
Ao fim da execução de todos os testes, o script deverá ser capaz de conectar em cada um dos clientes destes pares, e extrair o arquivo contendo o resultados dos testes.

Note que existem parâmetros que são definidos no próprio script:

(a) Nas últimas quatro linhas, há um bloco definindo o caminho da chave que será usada para fazer acesso às instâncias. Esta chave deve existir antes da execução do script, bem como deve estar carregada no ambiente da cloud, para que seja definida e usada por suas instâncias nos templates do Heat.

(b) Na linha 20, deve haver um comando do tipo:

    source $dir/henryson-cloudufscar-v3.sh

O usuário do script deve definir nesta linha o caminho de suas credenciais. Para fins de organização, foi deixado como padrão o mesmo caminho do script como diretório, bastando completar com o nome do arquivo das credenciais em si.
OBS: Note que, se for desejada a automatização completa do script, este arquivo das credenciais não deve pedir sua senha. Note também que neste caso, sua senha ficará em plain text neste arquivo.

(c) Os diretórios onde residem o próprio script, para que seja possível carregar os diretórios dos templates do Heat, e o diretório base para que se possa colocar as credenciais, se assim o usuário desejar.

(d) O servidor web usado para verificar o estado. Os estados possíveis são:
d.1- (A): Determina que a iteração de testes atual encerrou. Esta mudança de estado ocorre nas instâncias clientes da iteração atual.
d.2- (B): Que determina o momento em que um novo par de instâncias deve ser lançado. Esta mudança de estado ocorre no script, e sinaliza todas as instâncias para aguardarem (isto é, nenhum teste deve estar em execução).
d.3- (C): Que especifica o momento em que um novo teste deve iniciar. Esta mudança de estado ocorre somente na instância que foi executada mais recentemente, e afeta todas as instâncias em execução na iteração atual.
É um requisito de ambiente que, tanto o host onde o script é executado, como as instâncias dos testes, consigam acessar este host que executa o serviço web, e possa modificar o conteúdo de seu diretório /var/www/html - mais especificamente, o arquivo .txt que deve residir neste.

É um requisito de ambiente para que este script funcione, que o serviço de orquestração do OpenStack, *Heat*, esteja instalado no ambiente. São fornecidos dois templates para cada tipo de teste, de nomes:
    
    benchmark-<teste>-par<numero>.yml

onde <teste> pode ser "mtr" ou "iperf", sem aspas , e <numero>, que hoje abriga o par 1. Eles residem em seus próprios diretórios, a partir do diretório base onde fica o script. São eles:

Iperf-TCP para "iperf", e mtr para "mtr". Neles, também são definidos alguns parâmetros necessários para a execução dos testes:

(a) Qual a chave que será usada para o acesso às instâncias, definido no bloco *ssh_key*, e no valor do campo "default";

(b) Qual será a imagem usada para disparar as instâncias. É preferível que seja uma variante do Ubuntu Server. Isto fica definido no bloco *imagem*, e no valor do campo "default".

(c) Qual flavor será usado para cada instância. Cada arquivo de template define dois hosts - um servidor e um cliente. Estes são definidos pelos blocos <teste>Server1 e <teste>Client1, respectivamente. Nestes, o flavor é definido no campo *flavor* de cada um dos blocos.. Note que este parâmetro é sobrescrito quando o usuário especifica os flavors que deseja usar para o cliente e servidor na chamada do script.

(d) O endereço do servidor web. Este é escrito hardcoded no campo *user_data*, na seção "template". Este servidor será usado para consultas entre os pares e o script para observar em que estado o ciclo de execução se encontra no momento.

## Motivação

Este projeto foi criado com o intuito de avaliar rapidamente o desempenho de uma estrutura de cloud que foi levantada automaticamente por meio do uso do OSA. Sendo assim, um administrador de uma estrutura de OpenStack como essa deve ser capaz de verificar se existem pontos de saturação na alocação de recursos da mesma, sem que para isso seja necessário desenvolver um plano de experimento trabalhoso.

## Instalação

A obtenção do script e os templates usados para executar os testes deve ser obtido fazendo:

git clone ssh://git@git.ufscar.br:5522/ufscar-ufcg/cloud-tests.git

cd cloud-testes
