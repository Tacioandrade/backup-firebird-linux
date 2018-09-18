#!/bin/bash
# Criado: Tácio de Jesus Andrade - tacio@multiti.com.br
# Data: 30-05-2015
# Função: Script que executa o backup do Firebird compactado com senha no Mega.nz
# Informações: Antes de executar esse script corriga os caminhos das aplicações nas variáveis abaixo

# Variaveis do usuario e senha do firebird
user=SYSDBA
password=masterkey
# Variavel do dia do mes 1-31
DIA=`date | cut -d ' ' -f3`
# Variaveis de arquivos
LOG="/home/backup/BackupFirebird.log"
BACKUP="/home/backup/$DIA"
# Pasta onde estão os bancos de dados Firebird
BANCOS="/var/sgbd/"
# Senha para compactar os arquivos em 7zip
SENHACOMPACTAR="senha"
# Email
MAILDE="de@yahoo.com"
SENHAMAIL="SenhaEmail"
MAILPARA="para@email.com.br"
SMTP="smtp.mail.yahoo.com"
PORTA="465"

cd $BANCOS

echo "Backup iniciado `date`" >> $LOG

# Deleta os aquivos antigos
rm  $BACKUP/* 2> /dev/null

# Comando que faz a criacao do backup dos bancos de dados
for i in * ; do
	# Otimiza a base de dados
	gfix -sweep -user $user -password $password $i 2> /dev/null
	# Verifica os erros da base de dados
	gfix  -v -f -user $user -password $password $i 2> /dev/null
	# Faz o backup da base
	gbak -backup -v -ignore -user $user -pass $password $i "$BACKUP/$i.gbk" 2> /dev/null
done

# Vai ate a pasta dos backups
cd $BACKUP

# Compacta o backup em 7zip com senha
for i in * ; do
	7za a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -p$SENHACOMPACTAR $BACKUP/$i.7z $i > /dev/null
done

# Remove os arquivos de backup
rm $BACKUP/*gbk

# Vai até a o diretório de backup
cd $BACKUP

# Ativa o backup online
megarm "/Root/backup/$DIA" >> /dev/null
megamkdir /Root/backup/$DIA >> /dev/null
megacopy --local $BACKUP --remote /Root/backup/$DIA 2> /dev/null >> /dev/null

echo "Backup finalizado `date`" >> $LOG

# Envia um e-mail avisando do sucesso do backup
sendEmail -f $MAILDE -t $MAILPARA -u "Assunto" -m "Mensagem" -a $LOG -s $SMTP:$PORTA -xu $MAILDE -xp $SENHAMAIL
