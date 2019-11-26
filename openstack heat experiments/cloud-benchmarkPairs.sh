#!/bin/bash

# Tipo de teste que vai ser executado. Valores aceitaveis são "mtr" e "iperf", sem aspas.
teste=$1
# Quantidade de pares que devem ser levantados. Valor mínimo 1.
pares=$2
# Nome do flavor do servidor.
flavorS=$3
# Nome do flavor do cliente.
flavorC=$4

# IP do host que executa o servidor web necessario para sincronizar estado entre o script e as instancias de teste
IPweb=10.9.104.218

# Diretório base onde o script reside - o script assume que você está no diretório do mesmo.
dir=$(pwd)/

# Caminho das credenciais do OpenStack usadas para rodar os comandos dos cliente openstack. Estou assumindo que uma cópia de suas credenciais
# está no diretório do script.
source $dir/henryson-suporte-openrc-kc2.sh

# Dependendo do tipo de teste, o diretório onde estão os templates será diferente
if [ $teste == "mtr" ]; then testeDir=$dir/mtr
elif [ $teste == "iperf" ]; then testeDir=$dir/Iperf-TCP
fi


# Usado para debug
#echo "Teste selecionado: $teste"
#echo "Diretorio do teste: $testeDir"
vezesInstancia=0

for i in $(seq $pares); do
      #echo "Estou no loop $i de $pares"
      # Quando for o estado A...
      while true; do
	while [[ $(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://$IPweb/A.txt) -eq 200 ]] && [[ $vezesInstancia < $pares ]]; do
		#echo "Estou no ciclo $i dentro do while true"
        	ssh -o StrictHostKeyChecking=no henryson@$IPweb 'sudo mv /var/www/html/A.txt /var/www/html/B.txt'
		echo "Disparando instancia!"
		heat stack-create -f $testeDir/benchmark-$teste-par1.yml -P "flavorServer=$flavorS;flavorClient=$flavorC" benchmark-$(date +%s)
		let vezesInstancia++
		#echo "eu ja rodei a instancia $vezesInstancia vezes"
		#openstack --insecure stack create --template $testeDir/benchmark-$teste-par2.yml benchmark-$(date +%s)
                sleep 1
        done
        if [ $(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://$IPweb/A.txt) -eq 200 ] && [ $vezesInstancia == $pares ]; then break;fi
      done
done

# Usando o cliente do nova porque a versao do cliente na cloud de testes eh velha
#openstack --insecure server list | grep Client | grep private | cut -d' ' -f9 | cut -d '=' -f2 | cut -d ',' -f1 > /tmp/instancias_$teste
nova list | grep Client | grep private | cut -d '=' -f2 | cut -d ',' -f1 | cut -d ' ' -f1 > /tmp/instancias_$teste

# Jogando os resultados no /tmp. Por enquanto, deixei o diretório da chave hardcoded.
while read linha; do
    ssh-keygen -f "/home/henryson/.ssh/known_hosts" -R $linha
    scp -i /home/henryson/.ssh/henryson-kc2 -o StrictHostKeyChecking=no -r henryson@$linha:/home/ubuntu/$teste/* /tmp/
done < /tmp/instancias_$teste
