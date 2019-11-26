#!/bin/bash

############## PARTE 1/2 - reunir os certificados zipados em um diretorio ###########################
# DIRETORIO DOS CERTIFICADOS
certdir=/etc/openvpn/easy-rsa/keys
certzip=/tmp/certs-zipados

#Remove o diretorio se existir - depois, refaz ele
rm -rf $certzip
mkdir $certzip

# Pega todos os usuarios que possuem certificados atualmente
ls $certdir/*.crt | uniq | awk -F "/" '{ print $6 }' | awk -F "." '{ print $1 }' > /tmp/usuarios-vpn

# Zipa os certificados de cada pessoa individualmente
while read LINHA
do
        cd $certdir
        tar -zcvf $certzip/$LINHA.tar.gz $LINHA.* ca.crt
done < /tmp/usuarios-vpn

############## PARTE 2/2 - copiar para o diretorio do git e commitar ############################
# DIRETORIO DO REPOSITORIO
gitdir=/tmp/repositorio-certificados/vpn
gitdirParent=/tmp/repositorio-certificados

#Remove o diretorio do repositorio se existir - depois, refaz ele
rm -rf $gitdir

# Preparando o git para reconhecer voce
echo "Preciso do seu nome de usuario:"
read usuarioGit

echo "Preciso do seu nome no Git:"
read nomeGit

git config --global user.email "$usuarioGit@lsd.ufcg.edu.br"
git config --global user.name "$nomeGit"

# Clona o repositorio para a VM - isso tambem deve criar o diretorio de $gitdir
git clone https://$usuarioGit@git.example.com/ops/vpn.git $gitdir

# Agora vai sincronizar com o repositorio do git:
# Copia todos os zips para o diretorio do git
cp -R $certzip/* $gitdir/

# Prepara para adicionar todos os arquivos para o commit
cd $gitdir
git add $gitdir/*
# Commit nas modificacoes
git commit -m "Sincronizando certificados - atualizado do dia $(date +%Y-%m-%d) as $(date | awk '{print $4}')"
git push origin master

# Remove os lixos
rm -rf $gitdirParent
rm /tmp/usuarios-vpn
rm -rf $certzip
