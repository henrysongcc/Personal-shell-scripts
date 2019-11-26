#!/bin/bash

# Para servicos relacionados com NFS
service nfs-kernel-server stop; service rpcbind stop; service rpc-statd stop

# Antes de mexer nos diretorios sm e sm.bak, melhor saber quem eh o dono do diretorio antes
donoSM=$(ls -lh /var/lib/nfs | grep -w 'sm' | cut -d " " -f 3 | head -n 1)

donoCorreto=$(cat /etc/passwd | grep statd | cut -d ":" -f 1)
uidDC=$(cat /etc/passwd | grep $donoCorreto | cut -d ":" -f 3)
gidDC=$(cat /etc/passwd | grep $donoCorreto | cut -d ":" -f 4)

# Renomeia diretorios dos locks de NFS atuais
mv /var/lib/nfs/sm /var/lib/nfs/sm.bkp.$(date +%F)
mv /var/lib/nfs/sm.bak /var/lib/nfs/sm.bak.$(date +%F)

# Recria diretorios dos locks, e atribui permissoes
mkdir /var/lib/nfs/sm
chown $uidDC:$gidDC -R /var/lib/nfs/sm
mkdir /var/lib/nfs/sm.bak
chown $uidDC:$gidDC -R /var/lib/nfs/sm.bak

# Reinicia os servicos
service nfs-kernel-server start; service rpcbind start; service rpc-statd start
