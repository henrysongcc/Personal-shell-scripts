#!/bin/bash

DATAHORA=$(date +%F%t%T)
TEMPERATURA=`ipmitool -H 192.168.0.10 -U user -P password sdr type Temperature | grep 0Eh | cut -d'|' -f 5 | cut -d' ' -f 2`
echo -e $DATAHORA"\t"$TEMPERATURA >> /var/log/temp_minuto_a_minuto.log
