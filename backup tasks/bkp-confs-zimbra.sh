#!/bin/bash

# Este script vai transferir os backups mais estaticos do servidor - isso deve ocorrer uma vez por mes

DESTINO='root@srv-backup2:/backup2/zimbra-backups/'

# Interfaces
rsync -avz --progress /etc/network/interfaces $DESTINO

# Confs do Zimbra
rsync -avz --progress /backup/confs $DESTINO

echo "Backups do Zimbra concluidos - o diretorio $(tree /backup) foi transferido para srv-backup2" | mail -s "Backups Zimbra" henryson@lsd.ufcg.edu.br
