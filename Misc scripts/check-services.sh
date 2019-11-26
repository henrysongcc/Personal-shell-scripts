#!/bin/bash

# Checa se o apache e o etherpad-lite estao rodando
NOW=$(date +"%m-%d-%Y-%T")
service1=apache2
	if (( $(ps -ef | grep -v grep | grep $service1 | wc -l) > 0 ))
	then
		echo "$NOW [OK] $service1 esta rodando." >> /var/log/syslog
	else
		service $service1 start
	fi
