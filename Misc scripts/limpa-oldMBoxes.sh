#!/bin/bash

# Workaround para remover backups antigos - a parte a seguir nao funciona por causa da comparacao de string
echo "Tentando remover diretorios anteriores"
OLDMBOXES=$(ls /backup | grep '-')
echo "estes sao os diretorios: $OLDMBOXES"
for boxes in $OLDMBOXES; do
	rm -rf "/backup/$boxes/"
done
