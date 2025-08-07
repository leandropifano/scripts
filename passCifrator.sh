#!/bin/bash
###############################################################
#####FUNCIONES####################
function encodePass () {
echo $1 | openssl enc -aes-256-cbc -md sha512 -a -salt -pass pass:'5€cr3t#V4ult!passW0rd' > .secret_vault
chmod 600 .secret_vault
}

function decodePass () {
echo $1 | openssl enc -aes-256-cbc -md sha512 -a -d -salt -pass pass:'5€cr3t#V4ult!passW0rd'
}
##################################
#Uso------------------------------
#encodePass passACIFRAR
#decodePass $(cat .secret_vault)
#decodePass passCIFRADO
#---------------------------------
###############################################################
