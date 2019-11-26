#!/bin/bash

### RODE O SCRIPT COMO USUARIO zimbra ###

# Pega a lista
lista="clouds-l@lsd.ufcg.edu.br"

# Vasculha o txt e vai colocando cada usuario na lista
while read usuario; do
echo "Adicionando o usuario $usuario na lista $lista:"
zmprov adlm $lista "$usuario"

done < /tmp/FinalList.txt
