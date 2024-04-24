
#!/bin/sh


# Version de distro
OS_VER=$(cat /etc/os-release | grep VERSION_ID | grep -Eo "[0-9]+")


comprobar(){
	if [ $? -eq 0 ]; then
		echo -e "(V) - Correcto!\n"
	else
		echo -e "(ERROR) - Algo falló\n"
		exit 1
	fi
}


if [ $(whoami) == "root" ]; then
	clear

	echo -e "Bienvenido al script de instalación de wine...\n"
	sleep 3
	
	sudo apt update
	sleep 3

	echo -e "(!) - Comprobando dependencia wget...\n"
	which wget &> /dev/null
	if [ $? -eq 1 ]; then
		echo -e "(!) wget no se encontró en el sistema, se procederá a instalar...\n"
		sudo apt install -y wget
	fi
	comprobar
	sleep 3

	if [ $(sudo dpkg --print-foreign-architectures) == "" ]; then
		echo -e "(!) - Habilitando paquetes 32 bits...\n"
		sudo dpkg --add-architecture i386
		comprobar
		sleep 3
	fi

	if [ $(ls /etc/apt/ | grep keyrings) != "keyrings" ]; then
		echo -e "(!) - Creando directorio keyrings...\n"
		sudo mkdir -pm 755 /etc/apt/keyrings
		comprobar
		sleep 3
	fi

	echo -e "(!) - Copiando claves validadoras (repo wine)...\n"
	sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
	comprobar
	sleep 3

	echo -e "(!) - Escribiendo repositorio wine en sources.list.d...\n"
	if [ $OS_VER -eq 12 ]; then
		sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
	elif [ $OS_VER -eq 11 ]; then
		sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources
	else
		echo -e "(!) - Tu version de distro no está soportada :'( \n"
		exit 1
	fi
	comprobar
	sleep 3

	sudo apt update
	sleep 3

	echo -e "(!) - Instalando wine...\n"
	sudo apt install --install-recommends -y winehq-stable
	comprobar
	sleep 3

	echo -e "(!) Felicidades, wine ya está instalado en su sistema, antes de usarlo, ejecute 'winecfg' para instalar el paquete MONO (Importante para el funcionamiento de wine)...\n"
	sleep 3
	
	exit 0 # Bien :)
else
	echo -e "[ERROR] - Ejecute el el script con superusuario (root)"
	exit 1 # Mal :(
fi
