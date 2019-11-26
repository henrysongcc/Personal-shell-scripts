#!/bin/bash

directory=/opt/bkps-mysql

# Remove any previous dumps
rm $directory/dumpMySQL_*

/usr/bin/mysqldump --all-databases > $directory/dumpMySQL_$(date +"%d-%m-%y").sql
echo "Backup do MySQL concluido - o arquivo $(ls $directory) esta no diretorio $directory" | mail -s "Backup MySQL $(date +"%d-%m-%y")" suporte@example.com
