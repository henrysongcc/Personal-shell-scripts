#!/bin/bash

### RODE O SCRIPT COMO USUARIO zimbra ###

# Passe o parametro como o endereco completo do sujeito: ex - fulano@de.tal
USUARIO=$1

# Pega a lista
zmprov gadl > /tmp/listas_lsd.txt

# Vasculha TODAS as listas em busca do usuario
while read linha; do
	echo "----"
	echo "Procurando o usuario na lista $linha:"
	zmprov gdl $linha | grep $1;
	echo "----"
        echo " "
done < /tmp/listas_lsd.txt

# Remove o arquivo temporario que contem as listas
rm /tmp/listas_lsd.txt
