
__   __        _         _  _____                     _    
\ \ / /       (_)       (_)/  __ \                   | |   
 \ V /   __ _  _  _ __   _ | /  \/ _ __   __ _   ___ | | __
  \ /   / _` || || '_ \ | || |    | '__| / _` | / __|| |/ /
  | |  | (_| || || | | || || \__/\| |   | (_| || (__ |   < 
  \_/   \__,_||_||_| |_||_| \____/|_|    \__,_| \___||_|\_\
                                                           
-----------------
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

Comandos:

sudo apt-get update
sudo apt-get install aircrack-ng macchanger hcxdumptool hashcat reaver -y

Uso:
Para ejecutar el script, sigue los siguientes pasos.

Clona o descarga el script en tu sistema: sudo git clone https://github.com/Papote-M139/YainiCrack 

Asegúrate de que el script tenga permisos de ejecución: chmod +x YainiCrack.sh

Ejecuta el script como root: sudo ./YainiCrack.sh

Opciones:
El script acepta las siguientes opciones:

-a: Modo de ataque (Handshake, PKMID, WPA3).
-n: Nombre de la tarjeta de red.
-h: Mostrar el panel de ayuda.

Ejemplos de Uso:

Ataque Handshake: sudo ./s4viPwnWifi.sh -a Handshake -n wlan0

Ataque PKMID: sudo ./s4viPwnWifi.sh -a PKMID -n wlan0

Ataque WPA3: sudo ./s4viPwnWifi.sh -a WPA3 -n wlan0

Descripción de las Funciones:

ctrl_c()
Maneja las interrupciones del script (Ctrl+C), deteniendo la tarjeta de red y eliminando archivos temporales antes de salir.

helpPanel()
Muestra el panel de ayuda con las opciones disponibles y su uso.

dependencies()
Comprueba y, si es necesario, instala las dependencias requeridas para ejecutar el script.

selectNetworkCard()
Detecta y selecciona automáticamente la mejor tarjeta de red disponible para el ataque.

startAttack()
Inicia el ataque seleccionado (Handshake, PKMID, WPA3) configurando la tarjeta de red y ejecutando los comandos necesarios para capturar handshakes o hashes.

Notas Adicionales
El script debe ejecutarse como root para funcionar correctamente.
Asegúrate de usar este script de manera ética y legal, obteniendo siempre el permiso del propietario de la red antes de realizar cualquier tipo de prueba de penetración.



Este archivo README.txt proporciona una guía clara y detallada sobre cómo usar el script, instalar las dependencias necesarias y entender las funciones principales del script.
