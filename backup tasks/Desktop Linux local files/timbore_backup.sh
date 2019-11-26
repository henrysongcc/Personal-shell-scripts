#!/bin/bash

dirBackup=/local/henrysongcc/backup-timbore
dirRepo=/local/henrysongcc/git-lsd/backup-timbore

# Preciso copiar diretorios/arquivos importantes para um canto seguro:
# /etc/hosts
test -d $dirBackup/etc/ || mkdir -p $dirBackup/etc && cp -avrp /etc/hosts $dirBackup/etc/

# /etc/ssh
test -d $dirBackup/etc/ || mkdir -p $dirBackup/etc && cp -avrp /etc/ssh $dirBackup/etc/

# /home/henryson/.bashrc
test -d $dirBackup/home/henryson || mkdir -p $dirBackup/home/henryson && cp -avrp /home/henryson/.bashrc $dirBackup/home/henryson

# Chaves de ssh - /home/henryson/.ssh/
test -d $dirBackup/home/henryson || mkdir -p $dirBackup/home/henryson && cp -avrp /home/henryson/.ssh $dirBackup/home/henryson

# Minhas credenciais da cloud4 - /local/henrysongcc/Credenciais-clouds
test -d $dirBackup/local/henrysongcc || mkdir -p $dirBackup/local/henrysongcc && cp -avrp /local/henrysongcc/Credenciais-clouds $dirBackup/local/henrysongcc

# Manda tudo para o gitlab do LSD
rsync -avz --progress $dirBackup/ $dirRepo
cd $dirRepo
git add $dirRepo/*
git commit -m "Sincronizado arquivos do dia $(date +"%d-%m-%y")"
git push -u origin master

cd -
