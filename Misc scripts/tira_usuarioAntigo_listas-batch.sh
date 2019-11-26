#!/bin/bash

### EXECUTE COMO USUARIO zimbra ###
# Versao que executa o script para uma lista de individuos

while read individuoAtual; do
    USUARIO=$individuoAtual
    DOMINIO="@lsd.ufcg.edu.br"

#    if [[ $USUARIO == *"$DOMINIO"* ]]; then
#        # Pegar as listas as quais o usuario atual da iteracao pertence
#        zmprov gam $USUARIO@lsd.ufcg.edu.br > /tmp/listas_$USUARIO.txt
#        # Imprime as listas
#        echo "Listas que o usuario $USUARIO@lsd.ufcg.edu.br pertence:"
#        cat /tmp/listas_$USUARIO.txt
#        while read lista; do
#                echo "Removendo $USUARIO@lsd.ufcg.edu.br da lista $lista:"
#                zmprov rdlm $lista $USUARIO@lsd.ufcg.edu.br
#                echo "Feito."
#        done < /tmp/listas_$USUARIO.txt
#        echo "Marcando a conta do usuario $USUARIO como fechada:"
#        zmprov ma $USUARIO zimbraAccountStatus closed
#        echo "Feito."
#    else
        # Pega a lista de listas
        zmprov gadl > /tmp/listas_lsd.txt
        # Eh do LSD?
        if [[ $(zmprov ga $individuoAtual | grep AccountStatus | cut -d ":" -f2 | cut -d " " -f2) == "active" ]]; then
            echo "Eh um usuario do LSD - marcando conta como fechada"
            zmprov ma $USUARIO zimbraAccountStatus closed
            USUARIO=$USUARIO
#            echo "Complementando usuario com o dominio: $USUARIO"
        fi
        echo "O usuario pode ser de fora - preciso procurar em todas as listas ate encontra-lo nelas"
        #A partir do arquivo, sair removendo a criatura das listas
        while read linha; do
            echo "Verificando se precisa remover $individuoAtual da lista $linha:"
            if [[ $(zmprov gdl $linha | grep $individuoAtual) == *"$individuoAtual"* ]]; then
                zmprov rdlm $linha $individuoAtual
                echo "Usuario $individuoAtual removido da lista $linha."
            fi
        done < /tmp/listas_lsd.txt
#    fi
    # Remove os arquivos temporarios que contem as listas
    rm -f /tmp/listas_$individuoAtual.txt
    rm -f /tmp/listas_lsd.txt
done < /tmp/listaremovidos.txt
