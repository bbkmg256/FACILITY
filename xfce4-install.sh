#!/bin/bash

# Instalador de base xfce4 desatendida + complementos

# NOTA: Basicamente un sistema minimo con xfce4 y algunos que otros complementos
# PD de NOTA.: Ya dije que sistema minimo con xfce4 y alguna que otra cosa.

if [ $(whoami) == "root" ]; then
	clear

	echo -e "- Bienvenido al instalador de base xfce4 desatendido + complementos...\n"
	sleep 3

	# Modifica las lista de repos para aceptar paquete privativos
	# Tenga cuidado, ejcutarlo varias veces podria pisar el .bak original!
	echo -e "Modificando source.list...\n"
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
	sudo echo -e "deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware\ndeb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware\ndeb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware\ndeb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware" > /etc/apt/sources.list
	if [ $(echo $?) == 0 ]; then
		echo -e "[V] Todo correcto!\n"
	else
		echo -e "[ERROR] Algo falló...\n"
		exit 1
	fi
	sleep 2

	# Habilita paqueteria 32bits
	echo -e "[!] Configurando arquitecturas 32 bits...\n"
	sudo dpkg --add-architecture i386 &> /dev/null
	if [ $(echo $?) == 0 ]; then
		echo -e "[V] Todo correcto!\n"
	else
		echo -e "[ERROR] Algo falló...\n"
		exit 1
	fi
	sleep 2

	# Actualizado de paqueteria
	echo -e "[!] Actualizando lista de repositorios...\n"
	sudo apt update
	if [ $(echo $?) == 0 ]; then
		echo -e "[V] Todo correcto!\n"
	else
		echo -e "[ERROR] Algo falló...\n"
		exit 1
	fi
	sleep 2

	# Intalado de base xfce4
	echo -e "[!] Instalando base de xfce4...\n"
	sudo apt install -y xfdesktop4 xfwm4 xfce4-panel xfce4-settings xfce4-session thunar xfce4-power-manager xfce4-pulseaudio-plugin
	if [ $(echo $?) == 0 ]; then
		echo -e "[V] Todo correcto!\n"
	else
		echo -e "[ERROR] Algo falló...\n"
		exit 1
	fi
	sleep 2

	# Instalado de complementos utilies
	echo -e "[!] Instalando complementos útiles...\n"
	sudo apt install -y curl wget git zutty clamav ufw firefox-esr zsh linuxlogo network-manager network-manager-gnome pavucontrol pulseaudio neofetch gnome-themes-extra ntp htop rofi
	if [ $(echo $?) == 0 ]; then
		echo -e "[V] Todo correcto!\n"
	else
		echo -e "[ERROR] Algo falló...\n"
		exit 1
	fi
	sleep 2

	echo -e "[!] Instalación finalizada con exito, que tenga buen día :)\n"
	sleep 2
	exit 0

else
	echo -e "[ERROR] Ejecute este script como super usuario porfavor.\n"
	sleep 2
	exit 1
fi

















































































# NOTA de la PD de la NOTA: Sistema minimo con xfce4 y cositas varias :)
