#!/bin/bash

arquivosBackup=/home/suporte/Backup*
dirBackup=/backup2/switch-naoBacula

rsync -avz root@webmail:"$arquivosBackup" $dirBackup

printf "Backup dos switches concluido - os arquivos: \n\n$(ls -1 $dirBackup/Backup*) \n\nestao no diretorio $dirBackup" | mail -s "Backup Switches $(date +%F)" operadores-l@lsd.ufcg.edu.br
