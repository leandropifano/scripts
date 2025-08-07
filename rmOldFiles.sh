#!/bin/bash
#####################################################################################
#####SETEO VARIABLES##############
fromDIR="RUTA"
#>>Cuidado! busca y BORRA todo lo que tenga EXPRESION_ en su nombre
findDEL="EXPRESION_"
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LOG_DIR=$fromDIR/logs
LOG_FILE=$LOG_DIR/$(basename "$0" ".sh").log

##################################
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

function rmoldBacks () {
if [ $2 ];then
cd $2
local Nbacks=$(ls -tr | grep -c $1)

	if [ $Nbacks -gt 1 ];then
		echo -e "Se encontraron \e[1;33m$Nbacks\e[1;37m respaldos \e[1;32m($1)\e[1;37m en \e[1;34m$2\e[1;37m"
		let Nbacks--
		echo -e "Procediendo a borrar \e[1;33m$Nbacks\e[1;37m respaldos antiguos"
		for n in $(ls -tr | grep $1 | head -$Nbacks);
		do
			toLog "Borro respaldo antiguo $fromDIR$n"
			echo -e "Borrando \e[1;31m$n\e[1;37m" && rm $n
		done
	elif [ $Nbacks -eq 1 ];then
		echo -e "Se encontro un \e[1;32munico\e[1;37m respaldo"
		ls -tr | grep $1
	else
		echo -e "\e[1;33m**No se encontraron respaldos**\e[1;37m"
		toLog "**No se encontraron respaldos $1 en $2**"
	fi
else
	echo -e "No se puede ejecutar sin ruta especificada \e[1;34m[rmoldBacks FILE RUTA]\e[1;37m"
fi
}
##################################
rmoldBacks $findDEL $fromDIR
##--------------------------------
#####################################################################################
