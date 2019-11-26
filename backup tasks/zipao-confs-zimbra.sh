#!/bin/bash

HOJE=$(date +"%d-%m-%y")

tar cvpzf /backup/confs/zimbra/confs-zimbra-"$HOJE".tar.gz --exclude=./store /opt/zimbra
