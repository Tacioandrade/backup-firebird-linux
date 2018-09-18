# backup-firebird-linux
Script de backup do Firebird para Linux com o banco de dados compactado com 7zip, enviado para o Mega.nz usando o megatools e envio de email com sendEmail

# Configuração
Instale os pacotes p7zip p7zip-full megatools sendemail:
sudo apt-get install p7zip p7zip-full megatools sendemail

# Configuração do MegaTools
Crie o arquivo nano ~/.megarc com o seguinte conteúdo:

[Login]
Username = your@email
Password = yourpassword

# Configuração do Script
1 - Baixe o script e altere as variáveis para adaptar ao seu uso;

2 - Crie um job de backup com o crontab usando o comando "crontab -e", com um conteúdo parecido com o seguinte:
10 0 * * *   /usr/bin/backupFirebird.sh # Script que roda a meia noite e 10 todos o dias
