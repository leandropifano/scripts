#!/bin/bash
###############################################################
#####FUNCIONES EXTERNAS###########
source passCifrator.sh
#####SETEO VARIABLES##############
WORK_DIR=$(pwd)
LOG_DIR=$WORK_DIR/logs
LOG_FILE=$LOG_DIR/$(basename "$0" ".sh").log
DATETIME=$(date '+%Y%m%d_%H%M%S')

toHOST="IPscp"
toUSER="USUARIOssh"
toDIR="RUTAscp"

ftpHOST="IP_FTP"
ftpDIR="RUTAftp" #>sin / al final

fromHOSTNAME=$(/bin/hostname)
fromDIR="RUTAlocal"#>>sin / al final
fromFILES="ARCHIVOS"#>>(arch1 arch2 | *.bak | arch1 arch2 ^BAK.* )
file_BACK="EXPRESION_${fromHOSTNAME}_${DATETIME}.tar.gz"

SSH_ASKPASS_SCRIPT=$(pwd)/ssh-askpass-script
##################################

cat > ${SSH_ASKPASS_SCRIPT} <<EOF
#!/bin/bash
source passCifrator.sh
decodePass PASSWORDssh_CIFRADO
EOF
chmod 755 ${SSH_ASKPASS_SCRIPT}
export SSH_ASKPASS=${SSH_ASKPASS_SCRIPT}
#>>para que no se rompa si lo ponemos en el cron>>
export DISPLAY=:0
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#####FUNCIONES####################
function toLog () {
local DATE=$(date +%Y-%m-%d' '%H:%M:%S);
	if ! [ -d $LOG_DIR ];then
		mkdir $LOG_DIR
	fi
	echo "$DATE - $1"
	echo "$DATE - $1" >> $LOG_FILE
}
function copyFile () {
local file=$1
local IP=$2
local DIR=$3
	toLog "Copio $file a $DIR en $IP"
	setsid scp -oStrictHostKeyChecking=no -oLogLevel=error -oUserKnownHostsFile=/dev/null $file $toUSER@$IP:$DIR
}
function cpyFTP (){
local ftpU=$(decodePass USUARIOftp_CIFRADO)
local ftpP=$(decodePass PASSWORDftp_CIFRADO)

toLog "[FTP] Copio $1 a $3 en $2"
ftp -n -v $2 << EOT
user $ftpU $ftpP
cd $3
put $1
bye
EOT
}
##################################
##Empaquetado y compresion--------
cd $fromDIR/ && tar -czvf $file_BACK $fromFILES > /dev/null
##Copia SCP-----------------------
copyFile $file_BACK $toHOST $toDIR > /dev/null
rm ${SSH_ASKPASS_SCRIPT}
##Copia FTP-----------------------
cd $fromDIR && cpyFTP $file_BACK $ftpHOST $ftpDIR
##--------------------------------
###############################################################
