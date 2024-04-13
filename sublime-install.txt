#!/bin/sh

# mini-sh para instalar sublime en debian 12 :)
# bbkmg


comprobar(){
	if [ $? -eq 0 ]; then
		echo -e "(V) Correcto!\n"
	else
		echo -e "(Error) Algo salió mal! :(\n"
		exit 1
	fi
}


NULL="/dev/null"


if [ $(whoami) == "root" ]; then
	clear
	echo -e "(!) Iniciando script!\n"
	sleep 1

	# Comprobar wget
	echo -e "(!) Comprobando instalacion de Wget..."
	which wget &> $NULL
	if [ $? -eq 1 ]; then
		echo -e "(!) No tienes wget instalado, se procederá a instalar...\n"
		sudo apt update && sudo apt install wget
	else
		echo -e "(V) Wget instalado...\n"
	fi
	comprobar
	sleep 2
	
	# Crear dir keyrings
	echo -e "(!) Comprobando el dir. keyrings..."
	ls /etc/apt/ | grep keyrings &> $NULL
	if [ $? -eq 1 ]; then
		echo -e "(!) El directorio keyrings no está creado, se procederá a crearlo...\n"
		mkdir -pm 755 /etc/apt/keyrings
	fi
	comprobar
	sleep 2

	# Descargar clave gpg
	echo -e "(!) Descargando clave gpg..."
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/sublimehq-archive.gpg > /dev/null
	comprobar
	sleep 2
	
	# Agregar repo
	echo -e "(!) Agregando repo de sublime..."
	echo "deb [signed-by=/etc/apt/keyrings/sublimehq-archive.gpg] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list &> $NULL
	comprobar
	sleep 2

	# Instalar sublime
	echo -e "(!) Instalando sublime..."
	sudo apt update && sudo apt-get install apt-transport-https && sudo apt install sublime-text
	comprobar
	sleep 2

	# Fin
	echo -e "Sublime-text instalado exitosamente en el sistema, adiu! :)\n"
	exit 0
else
	echo -e "(Error) Ejecute el script como superusuario! :(\n"
	exit 1
fi
