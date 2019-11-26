#!/bin/bash

directory=/opt/bkps-mongodb

# Remove any previous dumps
rm -rf $directory/*

mongodump --host 10.20.6.6 --out $directory/dumpMongoDB_$(date +"%d-%m-%y")
echo "Backup do MongoDB concluido - o arquivo $(ls $directory) esta no diretorio $directory" | mail -s "Backup MongoDB $(date +"%d-%m-%y")" suporte@example.com
