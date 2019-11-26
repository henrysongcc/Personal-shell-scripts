#!/bin/bash

# Eu quero restaurar todos os os backups de um mes especifico do DB-c4-Influx
# Por ora, eu tenho uma lista bem definida de jobs, e vou testar com eles

while read JOBID
do
	echo "restore all jobid=$JOBID storage=c4-influx-st client=c4-influx-fd restoreclient=router-replica-fd where=/local/restore done yes" | bconsole
	sleep 5
done < /tmp/jobids.txt
