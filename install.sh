#!/bin/bash
#############################################################################################################
#   __  _| | | __ _ _   _  ___ __ _                                                                         #
#   \ \/ | | |/ _` | | | |/ __/ _` |                                                                        #
#    >  <| | | (_| | |_| | (_| (_| |                                                                        #
#   /_/\_|_|_|\__,_|\__,_|\___\__,_|                                                                        #
#############################################################################################################

# Variables para los colores
verde="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
rojo="\e[0;31m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
morado="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
gris="\e[0;37m\033[1m"

echo -e "\n${verde}[INICIANDO...]${endColour}\n"

#asignamos una shell a root
sudo chsh -s /bin/bash root
