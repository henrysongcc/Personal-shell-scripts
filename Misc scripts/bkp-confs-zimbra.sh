#!/bin/bash

# Este script vai transferir os backups mais estaticos do servidor - isso deve ocorrer uma vez por semana

DESTINO='root@srv-backup2:/backup2/zimbra-backups/'
MAIL="/opt/zimbra/postfix/sbin/sendmail"
# Confs do Host
rsync -avz --progress /etc/* $DESTINO

# Confs do Zimbra e caixa de entrada
rsync -avz --progress /backup $DESTINO


echo "Backups do Zimbra concluidos - o diretorio $(tree /backup) foi transferido para srv-backup2" | $MAIL -s "Backups Zimbra" suporte@lsd.ufcg.edu.br
