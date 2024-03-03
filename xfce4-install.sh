#!/bin/bash

# Chequea que las ejecuciones estén correctas...
comprobar() {
	if [ $(echo $?) == 0 ]; then
		echo -e "[V] Todo correcto!\n"
	else
		echo -e "[E] Algo falló...\n"
		exit 1
	fi
	sleep 2
}

# INICIO
if [ $(whoami) == "root" ]; then
	clear
	
 	echo -e "\n"
	echo "▀▄▀ █▀▀ █▀▀ █▀▀ ▄▄ █ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░ █▀▀ █▀█ █▀▀"
	echo "█░█ █▀░ █▄▄ ██▄ ░░ █ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄ ██▄ █▀▄ ██▄"
	echo -e "\n"
	
 	echo -e "- Bienvenido al instalador de base xfce4 mínimo + complementos...\n"
	echo -e "- by bbkmg...\n"
	sleep 3

	# Variable xd
	val=1
	
	# Modificación de las lista de repos para aceptar paquete privativos
	while [ $val -le 1 ]
	do
		read -p "[!] Desea modificar el fichero sources.list para paquetes privativos? (S / N): " opc

		if [[ $opc == "S" || $opc == "s" ]]; then
			ls /etc/apt | grep sources.list.bak &> /dev/null
			if [ $? == 1 ]; then
				echo -e "[!] Creando backup... \n"
				sleep 1
				sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
				echo -e "[!] Modificando sources.list...\n"
				sleep 1
				sudo cat ./src/deb-rep.txt &> /etc/apt/sources.list
				comprobar
			else
				echo -e "[!] El fichero sources.list.bak ya existe, no se realizará ningun cambio...\n"
			fi
			sleep 2
			break

		elif [[ $opc == "N" || $opc == "n" ]]; then
			echo -e "[!] Modificación de ficheros sources.list omitida...\n"
			sleep 2
			break
		else
			echo -e "[E] Opción no válida...\n"
			sleep 2
		fi
	done


	# Habilitación de paqueteria 32bits
	while [ $val -le 1 ]
	do
		read -p "[!] Habilitar paquetes 32bits? (S / N): " opc

		if [[ $opc == "S" || $opc == "s" ]]; then
			echo -e "[!] Configurando arquitecturas 32 bits...\n"
			sudo dpkg --add-architecture i386 &> /dev/null
			comprobar
			sleep 2
			break

		elif [[ $opc == "N" || $opc == "n" ]]; then
			echo -e "[!] Omitido...\n"
			sleep 2
			break

		else
			echo -e "[E] Opción no válida...\n"
			sleep 2
		fi
	done


	# Actualización de paqueteria
	echo -e "[!] Actualizando lista de repositorios...\n"
	sudo apt update
	comprobar
	sleep 2


	# Intalación de base xfce4
	echo -e "[!] Instalando base de xfce4...\n"

	sudo apt install -y $(cat ./src/xbase.txt | grep -v "#")
	comprobar
	sleep 2


	# Instalacion de complementos utiles
	while [ $val -le 1 ]
	do
		read -p "[!] Desea instalar algunos complementos útiles? (S / N): " opc

		if [[ $opc == "S" || $opc == "s" ]]; then
			echo -e "[!] Instalando complementos útiles...\n"

			sudo apt install -y $(cat ./src/compl.txt | grep -v "#")
			comprobar
			sleep 2
			break

		elif [[ $opc == "N" || $opc == "n" ]]; then
			echo -e "[!] Instalación de complementos omitida...\n"
			sleep 2
			break

		else
			echo -e "[E] Opción no válida...\n"
			sleep 2
		fi
	done


	echo -e "[!] Instalación finalizada con exito, que tenga buen día :)\n"
	sleep 2
	exit 0

else
	echo -e "[E] Ejecute este script como super usuario porfavor.\n"
	exit 1
fi
# FIN
