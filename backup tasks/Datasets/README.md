Este script é responsável por fazer backups dos datasets que estão em cofre para a máquina de backup Pupunha. 

Ele fica na pasta /root e está sendo executado toda sexta-feira às 20:00hs de acordo com o seguinte crontab:
0 20 * * 5 /root/backup.cofre.sh

É gerado um log em /var/log/backup.cofre

