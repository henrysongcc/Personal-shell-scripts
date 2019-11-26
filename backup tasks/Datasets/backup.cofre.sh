#!/bin/bash
# Script que faz o backup de alguns diretorios de mocinha
# O backup eh feito de forma rotacional sendo armazenado o home nos ultimos cinco dias
# A grande vantagem deste script eh o uso de hardlinks fazendo com que nao haja duplicacao de arquivos, ou seja,
# apenas quando existem diferencas nos arquivos eh que um novo arquivo vai ser criado.

############# Variaveis #########################
HOST="cofre"                                                    # hostname da maquina que sera feito o backup
DESTINODIR="/Backup-Datasets/"  # local onde sera feito o backup
DIRETORIOS="/datasets/"                         # lista dos diretorios (separados por espaco em branco) do host que terao o backup feito
LOG="/var/log/backup.cofre"
RELATORIO="/var/log/relatorio.semanal.backups"
#################################################

############### Execucao do backup #############
# A ideia eh fazer uma rotacao no backup da seguinte forma
# o backup de sete dias atras sera destruido
# o ultimo backup passara a ser o backup de um dias atras, o de um dia atras passara a ser o de dois dias e assim por diante
#rotate(){
#       rm -rf $DESTINODIR.5            2>  $LOG
#        mv $DESTINODIR.6 $DESTINODIR.7  2>> $LOG
#        mv $DESTINODIR.5 $DESTINODIR.6  2>> $LOG
#        mv $DESTINODIR.4 $DESTINODIR.5  2>> $LOG
#        mv $DESTINODIR.3 $DESTINODIR.4  2>> $LOG
#        mv $DESTINODIR.2 $DESTINODIR.3  2>> $LOG
#        mv $DESTINODIR.1 $DESTINODIR.2  2>> $LOG
#        mv $DESTINODIR $DESTINODIR.1    2>> $LOG
#        mkdir -p $DESTINODIR               2>> $LOG
#}


### Aqui eh onde esta o pulo do gato para fazer com que os arquivos que nao sofreram alteracoes nao sejam duplicados
### nem re-transferidos o que acaba por diminuir o tamanho do repositorio do backup.
sync(){
        rsync -progtl $HOST:$DIRETORIOS $DESTINODIR 2>> $LOG

}

### envia um email com o log da execucao do backup
#mail(){
#        if [ $(cat $LOG | wc -l) -gt 0 ]; then
#                sh /root/script/backup/mandaRelatorioBackupMail.sh $(date +%d/%m/%y) $0 $LOG
#        fi
#}

# -- Main -- #


#echo "Backup Banana iniciado em: $(date)" >> $RELATORIO
#echo "fazendo a rotacao dos dados" >> $RELATORIO
#rotate
#echo "fazendo o backup dos dados" >> $RELATORIO
sync
#echo "Script finalizado em: $(date)" >> $RELATORIO
#mail

