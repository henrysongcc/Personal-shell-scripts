#!/bin/bash
remetente="cobaia@lsd.ufcg.edu.br"
subject="Assunto"
body="Teste de envio de email para monitoramento"
destinatario="cobaia2@lsd.ufcg.edu.br"

(
echo "HELO linguado"
sleep 1s
echo "MAIL FROM: $remetente"
sleep 1s
echo "RCPT TO: $destinatario"
sleep 1s
echo "data"
sleep 1s
echo "Subject: $subject"
sleep 1s
echo "Content-Type: text/html"
sleep 1s
echo
echo "$body"
echo "."
sleep 1s
) | telnet mta-zimbra 25


