#!/bin/bash

# Os arquivos de conf nao mudam tanto - eles devem ser copiados uma vez por mes
HOJE=$(date +"%d-%m-%y")

# Remove a versao anterior - nao tem espaco suficiente para varias versoes
rm "/backup/confs/*"

tar cvpzf /backup/confs/confs-zimbra-"$HOJE".tar.gz --exclude=./store /opt/zimbra
