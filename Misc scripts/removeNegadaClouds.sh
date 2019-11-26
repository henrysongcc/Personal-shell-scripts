#!/bin/bash

### RODE O SCRIPT COMO USUARIO zimbra ###

# Pega a lista
lista="clouds-l@lsd.ufcg.edu.br"

# Vasculha o txt e vai colocando cada usuario na lista
while read usuario; do
echo "Removendo $usuario da lista $lista:"
zmprov rdlm $lista "$usuario"

done < /tmp/listanegada.txt
