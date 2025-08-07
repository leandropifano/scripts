#!/bin/bash 

# Excluyo segun version de sistema operativo
os_description=$(lsb_release -d | cut -f 2)
if [[ $os_description != "openSUSE Leap 42.3" ]]; then
  echo "Este equipo fue excluido del proceso de desactivacion de actualizaciones automaticas."
  exit 0
fi

# Desactivar las actualizaciones automáticas
sudo sed -i 's/^# solver.onlyRequiresConfirmation = false/solver.onlyRequiresConfirmation = true/' /etc/zypp/zypp.conf 

# Desactivar los mensajes en pantalla
sudo sed -i 's/^# multiversion.displayAllowNewer = yes/multiversion.displayAllowNewer = no/' /etc/zypp/zypp.conf 

# Abrir el archivo de configuración
conf_file="/etc/zypp/zypp.conf"
if ! test -f "$conf_file"; then
   echo "No se encontró el archivo de configuración: $conf_file"
   exit 1
fi 

# Deshabilitar los carteles de actualización
sed -i 's/solver.onlyRequires = true/solver.onlyRequires = false/' "$conf_file" 

# Deshabilitar todos los repositorios
zypper modifyrepo --all --disable echo "Se han desactivado las actualizaciones automáticas y los mensajes en pantalla. El servicio de actualizaciones ha sido reiniciado."