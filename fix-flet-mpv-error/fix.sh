#!/bin/sh

# Solucion al problema con flet:
#	error while loading shared libraries: libmpv.so.1: cannot open shared object file: No such file or directory

# vars.
LIBR="libmpv.so.1"
LIB_LOCAL="/usr/local/lib/"
LIB_LIB="/usr/lib/"

# proced.
compr(){
	if [ $? -gt 0 ]; then
		echo -e "(ERROR) Algo a fallado :'(\n"
		exit 1
	else
		echo -e "(V) Realizado con exito!\n"
	fi

	sleep 1
}

# begin
if [ $(whoami) == "root" ]; then
	echo -e "(!) Instalando mpv y sus paquetes dev ...\n"
	sudo apt update && sudo apt install libmpv-dev mpv
	compr

	echo -e "(!) Copiando la libreria ${LIBR} ...\n"
	sudo cp $LIBR $LIB_LOCAL
	compr

	echo -e "(!) Creando enlace simbolico a de ${LIB_LOCAL} a ${LIB_LIB} ...\n"
	sudo ln -sr ${LIB_LOCAL}${LIBR} $LIB_LIB
	compr

	echo -e "Solucion finalizada con exito, tenga buen día...\n"
	exit 0
else
	echo -e "(ERROR) Ejecute el comando en modo root :'(\n"
	exit 1
fi
# end
