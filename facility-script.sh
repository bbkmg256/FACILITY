#!/bin/sh

# Chequea que las ejecuciones estén correctas...
comprobar() {
	if [ $(echo $?) == 0 ]; then
		echo -e "$CORRECTO - Todo correcto!\n"
	else
		echo -e "$ERROR - Algo falló...\n"
		exit 1
	fi
	sleep 2
}


# CONST
# Colores
NORMAL="[1;37m"
VERDE="[1;32m"
AMARILLO="[1;33m"
ROJO="[1;31m"
MAGENTA="[1;35m"

# Carteles
AVISO="\e$AMARILLO !\e$NORMAL"
ERROR="\e$ROJO E\e$NORMAL"
CORRECTO="\e$VERDE V\e$NORMAL"

# Rutas
SRCL="/etc/apt/sources.list"
NULL="/dev/null"


# INICIO
if [ $(whoami) == "root" ]; then
	# Limpieza de terminal...
 	clear

 	# Banner...
 	echo -e "\n"
	echo -e "\e$VERDE"
	echo -e '    dMMMMMP .aMMMb  .aMMMb  dMP dMP     dMP dMMMMMMP dMP dMP' 
	echo -e '   dMP     dMP"dMP dMP"VMP amr dMP     amr    dMP   dMP.dMP '  
	echo -e '  dMMMP   dMMMMMP dMP     dMP dMP     dMP    dMP    VMMMMP  '   
	echo -e ' dMP     dMP dMP dMP.aMP dMP dMP     dMP    dMP   dA .dMP   '    
	echo -e 'dMP     dMP dMP  VMMMP" dMP dMMMMMP dMP    dMP    VMMMP"    '     
                                                             
	echo -e "\e$NORMAL\n"
 	echo "- Bienvenido FACILITY-script..."
	echo -e "- by\e$MAGENTA bbkmg\e$NORMAL...\n"
	sleep 3
	

	# Modificación de las lista de repos para aceptar paquete privativos
	while [ 1 -le 1 ]
	do
		read -p " ? - Desea modificar el fichero sources.list para paquetes privativos? (S / N): " opc

		if [[ $opc == "S" || $opc == "s" ]]; then
			ls /etc/apt | grep sources.list.bak &> $NULL
			if [ $? == 1 ]; then
				echo -e "$AVISO - Creando backup... \n"
				sleep 1
				sudo cp $SRCL $SRCL.bak
				echo -e "$AVISO - Modificando sources.list...\n"
				sleep 1
				sudo sed -i "s/main/main contrib non-free/g" $SRCL
				#sudo cat ./src/deb-rep.txt &> /etc/apt/sources.list # obsoleto...
				comprobar
			else
				echo -e "$AVISO - El fichero sources.list.bak ya existe, no se realizará ningun cambio...\n"
			fi
			sleep 2
			break

		elif [[ $opc == "N" || $opc == "n" ]]; then
			echo -e "$AVISO - Modificación de ficheros sources.list omitida...\n"
			sleep 2
			break
		else
			echo -e "$ERROR - Opción no válida...\n"
			sleep 2
		fi
	done


	# Habilitación de paqueteria 32bits
	while [ 1 -le 1 ]
	do
		read -p " ? - Habilitar paquetes 32bits? (S / N): " opc

		if [[ $opc == "S" || $opc == "s" ]]; then
			echo -e "$AVISO - Configurando arquitecturas 32 bits...\n"
			sudo dpkg --add-architecture i386 &> $NULL
			comprobar
			sleep 2
			break

		elif [[ $opc == "N" || $opc == "n" ]]; then
			echo -e "$AVISO - Omitido...\n"
			sleep 2
			break

		else
			echo -e "$ERROR - Opción no válida...\n"
			sleep 2
		fi
	done


	# Actualización de paqueteria
	echo -e "$AVISO - Actualizando lista de repositorios...\n"
	sudo apt update
	comprobar
	sleep 2


	# Intalación de base xfce4
	echo -e "$AVISO - Instalando base de xfce4...\n"

	sudo apt install -y $(cat ./src/xbase.txt | grep -v "#")
	comprobar
	sleep 2


	# Instalacion de complementos utiles
	while [ 1 -le 1 ]
	do
		read -p " ? - Desea instalar algunos complementos útiles? (S / N): " opc

		if [[ $opc == "S" || $opc == "s" ]]; then
			echo -e "$AVISO - Instalando complementos útiles...\n"

			sudo apt install -y $(cat ./src/compl.txt | grep -v "#")
			comprobar
			sleep 2
			break

		elif [[ $opc == "N" || $opc == "n" ]]; then
			echo -e "$AVISO - Instalación de complementos omitida...\n"
			sleep 2
			break

		else
			echo -e "$ERROR - Opción no válida...\n"
			sleep 2
		fi
	done


	echo -e "$CORRECTO - Instalación finalizada con exito, que tenga buen día :)\n"
	sleep 2
	exit 0

else
	echo -e "$ERROR - Ejecute este script como super usuario porfavor.\n"
	exit 1
fi
# FIN
