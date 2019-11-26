#!/bin/bash

IP=oneview3-dev
USERNAME=Administrator
PASSWORD=pass
OUTPUT=/backup2/oneview3-dev-backup

# Delete any possible previous backup files
rm -rf $OUTPUT/*

# Generates a current backup file
/usr/local/bin/oneview-backup -i $IP -u $USERNAME -p $PASSWORD -o $OUTPUT

echo "Backup de oneview3-dev concluido - o arquivo $(ls $OUTPUT) esta no diretorio $OUTPUT" | mail -s "Backup Oneview3-dev" henryson@lsd.ufcg.edu.br
