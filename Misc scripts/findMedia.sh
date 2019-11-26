#!/bin/bash

#O objetivo desse script eh achar todos os tipos de arquivos que nao deveriam estar no /home do povo
# Isto inclui arquivos de midia (audio e video), arquivos de disco e de snapshots de VMs

# Se livra de possiveis lixos que tenham sobrado de execucoes interrompidas do script anteriormente
rm /var/log/mediaFound_*

# Agrupando por Usuarios
# Listando os diretorios dos Usuarios e guardando em uma variavel
diretorios=$(find /home/ -maxdepth 1 -mindepth 1 -type d -printf '%f\n')

# Guardando a data de hoje
hoje=$(date +%d-%m-%Y)
echo $diretorios
for each in $diretorios
do
	#Final do nome do arquivo
	PessoaData=$each$hoje
	echo $PessoaData

	printf "Os seguintes arquivos foram encontrados - que segundo a politica do laboratorio, nao deveriam ficar guardados no diretorio /home:\n\n" > /var/log/mediaFound_$PessoaData.txt
	# Encontrando videos
	find /home/$each -type f -name '*.mkv' -o -name '*.mp4' -o -name '*.wmv' -o -name '*.flv' \
	-o -name '*.webm' -o -name '*.mov' -o -name '*.avi' >> /var/log/mediaFound_$PessoaData.txt

	# Encontrando audios
	find /home/$each -type f -name '*.mp3' -o -name '*.wma' -o -name '*.rm' -o -name '*.mid*' \
	-o -name '*.ogg' >> /var/log/mediaFound_$PessoaData.txt

	# Encontrando formatos de disco e snapshot de imagens de VM
	find /home/$each -type f -name '*.vdi' -o -name '*.vmdk' -o -name '*.qcow2' -o -name '*.qcow' \
	-o -name '*.ISO' -o -name '*.raw' -o -name '*.vdh' -o -name '*.ovf' \
	-o -name '*.ova' >> /var/log/mediaFound_$PessoaData.txt

	cat /root/textoAuxiliarfindMedia.txt >> /var/log/mediaFound_$PessoaData.txt
	# Se prepara para enviar e-mail para essa pessoa
	# Deve mandar o e-mail apenas se tiver encontrado alguma midia
	mandaEmail=0

	if [ -s /var/log/mediaFound_$PessoaData.txt ]
	then
		mandaEmail=1
	fi

	if [ $mandaEmail==1 ]
	then
		mail -s "Atentar ao conteudo de seu diretorio /home" \
		${each}@lsd.ufcg.edu.br < /var/log/mediaFound_$PessoaData.txt
		#ls $diretorios
	fi

	# Se livra dos arquivos que listam as midias de cada usuario
	rm /var/log/mediaFound_*
done
