#!/bin/bash

echo > /root/email.txt
echo "==========================================" > /root/email.txt
echo "Teste de monitoramento dos serviços" >> /root/email.txt
echo "==========================================" >> /root/email.txt

echo "1-Medindo o espaco em disco " >> /root/email.txt

df -h >> /root/email.txt

echo >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt

echo "2-Testando o RAID em Linguado " >> /root/email.txt


RAID=`(mpt-status -i 2 | head -1 | awk '{print $2, $3}' )`
RAID_S=`(mpt-status -i 2 | head -1 | awk '{print $11}')`
Disco1=`(mpt-status -i 2 | grep "phy 1"| awk '{print $2, $3}')`
Disco1_S=`(mpt-status -i 2 | grep "phy 1"|awk '{print $12}')`
Disco0=`(mpt-status -i 2 | grep "phy 0"|awk '{print $2, $3}')`
Disco0_S=`(mpt-status -i 2 | grep "phy 0"|awk '{print $12}' )`

#echo "Estado do RAID $RAID: $RAID_S disco $Disco1 = $Disco1_S e disco $Disco0 = $Disco0_S." >> /root/email.txt
/usr/sbin/mpt-status -i 2 >> /root/email.txt
#echo $RAID | tee /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt

echo "7-Testando Raid em Salmonete" >> /root/email.txt

ssh root@salmonete 'mpt-status -i 0' >> /root/email.txt

echo "3-Testando temperatura pelo servidor Linguado-DRAC" >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt

#Henryson# Deixar isso aqui enquanto o iDRAC em linguado nao funciona localmente
tail -n1 /var/log/temp_minuto_a_minuto_"$(date +%F%t)".log | tr ' ' '\t' | cut -f3 >> /root/email.txt
#ipmitool -H 192.168.0.10 -U user -P password sdr type Temperature | grep 0Eh | cut -d'|' -f 5 >> /root/email.txt

echo >> /root/email.txt
echo >> /root/email.txt
echo "==========================================" >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt

echo "4-Testando o envio de emails" >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt
/etc/monitoramento/teste_email.sh > /root/resultado_email.txt

if grep -qs 'queued ' /root/resultado_email.txt;
        then
        echo "Teste terminou com SUCESSO " >> /root/email.txt ;
                else
                echo "Envio de email falhou. Verificar servidor" >> /root/email.txt;
fi


echo >> /root/email.txt
echo >> /root/email.txt
echo "==========================================" >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt
echo "5-Testando paginas web" >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt
wget www2.example.com/~user/index.html
if [ $? -eq 0 ];
        then echo "Paginas dos usuarios OK" >> /root/email.txt;
        else echo "Paginas dos usuarios não está funcionando. Certifique-se que o apache está rodando e o /home está montado no host mocinha" >> /root/email.txt;
fi

rm index.html

echo >> /root/email.txt
echo >> /root/email.txt

wget www.example.com
if [ $? -eq 0 ];
        then echo "Site OK" >> /root/email.txt;
        else echo "Site down. Certifique-se que a maquina virtual salmonete está funcionando normalmente." >> /root/email.txt;
fi

echo "6-Testando DNS em mocinha" >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt
nslookup www.google.com >> /root/email.txt
echo >> /root/email.txt
echo >> /root/email.txt


mail -s "Teste de monitoramento da infraestrutura do LSD" henryson@lsd.ufcg.edu.br < /root/email.txt

rm *index*

