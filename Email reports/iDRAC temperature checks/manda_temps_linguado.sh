#!/bin/bash

# Eu quero enviar ao meio dia o arquivo /var/log/temp_minuto_a_minuto.log
scp /var/log/temp_minuto_a_minuto_"$(date +%F%t)".log suporte@linguado:/tmp

