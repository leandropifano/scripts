####SCRIPT QUE BORRA LOS ARCHIVOS BASURA QUE GENERA MAC OS######
####------------------------------------------------------------------------------------------
#!/bin/bash
#Muestro la ruta en la que voy a borrar
pwd
echo "^^-------------------------------------------------------------------------------------^^"
#Pregunto
read -p "¿Borrar RECURSIVAMENTE TODOS los archivos '.DS_STORE' y '._nombre.extension'? (y/n)" resp
#Opciones
case "$resp" in
        y|Y|s|S )       find ./ -name '.DS*' -exec rm -fvI {} \;
                        find ./ -name '._*' -exec rm -fvI {} \;
                ;;
        n|N )   echo "ABORTADO";;
        * )     echo "Opcion incorrecta!";;
esac
echo "^^------------------------------------------------------------------------------------^^"
####------------------------------------------------------------------------------------------
