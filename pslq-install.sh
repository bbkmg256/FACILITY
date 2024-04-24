#!/bin/sh

# PostgresSQL script installer xd

NULL="/dev/null"
KR="/etc/apt/keyrings"
ARCH=$(dpkg --print-architecture)

compr(){
	if [ $? -gt 0 ]; then
		echo -e "(Error) Algo falló! :(\n"
		exit 1
	else
		echo -e "(V) Realizado con exito!\n"
	fi

	sleep 2
}


if [ $(whoami) == "root" ]; then	
	clear
	
	cat <<- EOF

	@@@@@@@   @@@@@@  @@@@@@   @@@               @@@ @@@  @@@  @@@@@@ @@@@@@@  @@@@@@  @@@      @@@          @@@@@@ @@@  @@@
	@@!  @@@ !@@     @@!  @@@  @@!               @@! @@!@!@@@ !@@       @@!   @@!  @@@ @@!      @@!         !@@     @@!  @@@
	@!@@!@!   !@@!!  @!@  !@!  @!!      @!@!@!@! !!@ @!@@!!@!  !@@!!    @!!   @!@!@!@! @!!      @!!          !@@!!  @!@!@!@!
	!!:          !:! !!:!!:!:  !!:               !!: !!:  !!!     !:!   !!:   !!:  !!! !!:      !!:             !:! !!:  !!!
	 :       ::.: :   : :. ::: : ::.: :          :   ::    :  ::.: :     :     :   : : : ::.: : : ::.: : :: ::.: :   :   : :

	(!) Iniciando script de instalación ...
	EOF

	# Comprobar arquitectura
	if [ $ARCH == "i386" ]; then
		echo -e "(Error) psql no admite arquitectura 32bits :(\n"
		exit 0
	fi
	
	# Comprobar wget
	echo -e "(!) Comprobando wget ...\n"
	which wget &> $NULL
	if [ $? -gt 0 ]; then # Mayor a ...
		echo -e "(!) wget no está instalado en el sistema, se procede a instalar ...\n"
		sudo apt install -y wget
	fi
	compr

	# Comprobar dir keyrings
	echo -e "(!) Comprobando dir. keyrings... \n"
	ls $KR &> $NULL
	if [ $? -gt 0 ]; then
		echo -e "(!) No se ah encontrado el directorio keyrings, se procede a crear el mismo ...\n"
		mkdir -pm 755 $KR
	fi
	compr

	# Copiar clave de repo
	echo -e "(!) Copiando clave de verificacion de repo ...\n"
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | tee $KR/ACCC4CF8.asc &> $NULL
	compr

	# Copiando repo
	echo -e "(!) Copiando el repo a sources.list.d ...\n"
	echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/ACCC4CF8.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs | tail)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
	compr

	# Instalar psql
	read -p "(!) Desea instalar la ultima version o procederá a instalar por su cuenta una version especifica? (S/N): " opc
	while [ 1 -le 1 ]; do
		if [[ $opc == "s" || $opc == "S" ]]; then
			echo -e "(!) Instalando postgresSQL ...\n"
			sudo apt update && sudo apt install -y postgresql
			break
		elif [[ $opc  == "n" || $opc == "N" ]]; then
			echo -e "(!) Perfecto!\n"
			break
		else
			echo -e "(Error) Ingrese una opcion valida!\n"
		fi
	done
	compr

	# Fin
	echo -e "(V) Hecho!, tenga buen día :)\n"
	exit 0
else
	echo -e "(Error) Ejecute el script con super-usuario.\n"
	exit 1
fi
