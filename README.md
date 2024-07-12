
__   __        _         _  _____                     _    
\ \ / /       (_)       (_)/  __ \                   | |   
 \ V /   __ _  _  _ __   _ | /  \/ _ __   __ _   ___ | | __
  \ /   / _` || || '_ \ | || |    | '__| / _` | / __|| |/ /
  | |  | (_| || || | | || || \__/\| |   | (_| || (__ |   < 
  \_/   \__,_||_||_| |_||_| \____/|_|    \__,_| \___||_|\_\
                                                           
------------

Author: s4vitar - nmap y pa' dentro

Mejorado por Papote-M139 - Name version: YainiCrack -  actualizacion 2024

s4viPwnWifi Script Mejorado

Este script ha sido diseñado para realizar ataques a redes Wi-Fi, incluyendo Handshake, PKMID y WPA3. Es una mejora del script original creado por s4vitar, con actualizaciones para 2024.

 Requisitos

Antes de ejecutar el script, asegúrate de tener las siguientes herramientas instaladas en tu sistema:

- aircrack-ng
- macchanger
- hcxdumptool
- hashcat
- reaver

El script es totalmente compatible con Kali Linux.

 Instalación

Si las herramientas necesarias no están instaladas, el script intentará instalarlas automáticamente. No obstante, es recomendable instalarlas manualmente antes de ejecutar el script para evitar problemas.

Para instalar las herramientas manualmente, puedes usar los siguientes comandos:

```bash
sudo apt-get update
sudo apt-get install aircrack-ng macchanger hcxdumptool hashcat reaver -y
