#!/bin/bash

touch /tmp/catalogo-$(date +%F).txt

hoje=$(date +%F)

catalogoHoje="/tmp/catalogo-$hoje.txt"

echo " " >> $catalogoHoje
echo "list jobs" | bconsole | grep "$hoje"  >> $catalogoHoje

echo "Catalogo de jobs do Bacula em srv-backup2: $(cat $catalogoHoje)" | mail -s "Catalogo bacula srv-backup2" suporte@example.com
