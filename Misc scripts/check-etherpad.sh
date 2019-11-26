#!/bin/bash

service2=etherpad-lite
NOW=$(date +"%m-%d-%Y-%T")
STATUS=$(ps aux | grep etherpad | wc -l)
if [ $STATUS -ge 1 ]
then
echo "$NOW [OK] $service2 esta rodando." >> /var/log/syslog
else
service $service2 start
fi
