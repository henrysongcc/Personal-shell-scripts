#!/bin/bash

directory=/opt/bkps-postgre

# Remove any previous dumps
rm $directory/dump_Postgre_*

su postgres -c "/usr/bin/pg_dumpall > $directory/dump_Postgre_$(date +"%d-%m-%y").out"

echo "Backup do PostgreSQL concluido - o arquivo $(ls $directory) esta no diretorio $directory" | mail -s "Backup PostgreSQL $(date +"%d-%m-%y")" suporte@example.com
