#!/bin/bash

# Instalador de base xfce4 desatendida + complementos

# NOTA: Por el momento esto está hardcodeado :(
# pero funciona :)

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
	echo "▐▄• ▄ ·▄▄▄ ▄▄· ▄▄▄ .▪   ▐ ▄ .▄▄ · ▄▄▄▄▄ ▄▄▄· ▄▄▌  ▄▄▌  ▄▄▄ .▄▄▄  "
	echo " █▌█▌▪▐▄▄·▐█ ▌▪▀▄.▀·██ •█▌▐█▐█ ▀. •██  ▐█ ▀█ ██•  ██•  ▀▄.▀·▀▄ █·"
	echo " ·██· ██▪ ██ ▄▄▐▀▀▪▄▐█·▐█▐▐▌▄▀▀▀█▄ ▐█.▪▄█▀▀█ ██▪  ██▪  ▐▀▀▪▄▐▀▀▄ "
	echo "▪▐█·█▌██▌.▐███▌▐█▄▄▌▐█▌██▐█▌▐█▄▪▐█ ▐█▌·▐█ ▪▐▌▐█▌▐▌▐█▌▐▌▐█▄▄▌▐█•█▌"
	echo "•▀▀ ▀▀▀▀▀ ·▀▀▀  ▀▀▀ ▀▀▀▀▀ █▪ ▀▀▀▀  ▀▀▀  ▀  ▀ .▀▀▀ .▀▀▀  ▀▀▀ .▀  ▀"

	echo -e "- Bienvenido al instalador de base xfce4 desatendido + complementos...\n"
	sleep 3

	
	# Modificacion de las lista de repos para aceptar paquete privativos
	val=$(ls /etc/apt | grep sources.list.bak)
	if [ $val == "" ]; then
		echo -e "[!] Modificando sources.list...\n"
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
		sudo echo -e "deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware\ndeb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware\ndeb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware\ndeb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware" > /etc/apt/sources.list
		comprobar
	else
		echo -e "[!] El fichero sources.list.bak ya existe, no se realizará ningun cambio...\n"
		sleep 2
	fi


	# Habilitación de paqueteria 32bits
	echo -e "[!] Configurando arquitecturas 32 bits...\n"
	sudo dpkg --add-architecture i386 &> /dev/null
	comprobar


	# Actualización de paqueteria
	echo -e "[!] Actualizando lista de repositorios...\n"
	sudo apt update
	comprobar


	# Intalación de base xfce4
	echo -e "[!] Instalando base de xfce4...\n"

	sudo apt install -y xfdesktop4 xfwm4 xfce4-panel xfce4-settings\
	xfce4-session thunar xfce4-power-manager xfce4-pulseaudio-plugin xfce4-notifyd

	comprobar


	# Instalacion de complementos utiles
	val=1
	while [ $val -le 1 ]
	do
		echo -n "[!] Desea instalar algunos complementos útiles? (S / N): "; read opc
		if [[ $opc == "S" || $opc == "s" ]]; then
			echo -e "[!] Instalando complementos útiles...\n"

			sudo apt install -y curl wget git zutty clamav ufw\
			firefox-esr zsh linuxlogo network-manager network-manager-gnome\
			pavucontrol pulseaudio neofetch gnome-themes-extra ntp htop rofi xarchiver

			comprobar
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
	sleep 2
	exit 1
fi
# FIN
