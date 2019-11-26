#!/bin/bash

IP=oneview3-prod
USERNAME=Administrator
PASSWORD='pass'
OUTPUT=/backup2/oneview3-prod-backup

# Delete any existing previous backup files
rm -rf $OUTPUT/*

# Generates a current backup file
/usr/local/bin/oneview-backup -i $IP -u $USERNAME -p $PASSWORD -o $OUTPUT

echo "Backup de oneview3-prod concluido - o arquivo $(ls $OUTPUT) esta no diretorio $OUTPUT" | mail -s "Backup Oneview3-prod" henryson@lsd.ufcg.edu.br
