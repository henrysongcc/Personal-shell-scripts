#!/bin/bash

# RODE COMO SUDO

dirBackup=/local/henrysongcc/backup-timbore
dirgit=/local/henrysongcc/git-lsd/
dirRepo=/local/henrysongcc/git-lsd/backup-timbore

# Pega do repositorio as ultimas versoes dos arquivos - via HTTPS, ja que nao vou ter a chave na hora
sudo mkdir -p $dirgit
cd $dirRepo

git clone https://git.lsd.ufcg.edu.br/henryson/backup-timbore.git

rsync -avz --progress $dirRepo/ $dirBackup

# Preciso restaurar diretorios/arquivos importantes para os respectivos diretorios:
# /etc/hosts
cp -a $dirBackup/etc/hosts /etc

# /etc/ssh
cp -a $dirBackup/etc/ssh /etc

# /home/henryson/.bashrc
cp -a $dirBackup/home/henryson/.bashrc /home/henryson

# Chaves de ssh - /home/henryson/.ssh/
cp -a $dirBackup/home/henryson/.ssh /home/henryson
