temp_minuto_a_minuto.sh: Colhe a temperatura do hardware iDRAC e salva no arquivo /var/log/tem_minuto_a_minuto.log
O script é rodado de minuto a minuto em cofre de acordo com o crontab: * * * * *  /root/temp_minuto_a_minuto.sh

-----------------------------------

mail.temperatura: script responsável por enviar emails com a temperatura do sistema medido pelo iDRAC pelo script temp_minuto_a_munuto.sh.
O script colhe as informações salvas no arquivo /var/log/temp_minuto_a_minuto e envia para a lista de emails cadastradas no script.
O script é rodado diariamente em linguado as 12:05hs pelo crontab: 5 12 * * * /root/mail.temperatura

----------------------------------

manda_temps_linguado.sh: Script que envia os arquivos de temperatura coletados para a máquina linguado, isso se faz necessário pois a temperatura não pode ser coletada diretamente da máquina linguado.
Esse script roda às 11:57 todos os dias na máquina cofre pelo crontab: 57 11 * * * /opt/manda_temps_linguado.sh
