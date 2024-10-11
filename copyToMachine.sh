#! /bin/bash

# Copy game to machine for assets testing etx
# Charles Shapiro 11 Oct 2024

DESTDIR=/media/devel/PLAYDATE/Games/User
status=TRUE
GAMEZIP=${HOME}/Playdate_src/Mandala/Mandala.zip
GAME=${DESTDIR}/Mandala.pdx

if [ ! -d ${GAME} ]
then
    echo Oops. Must connect playdate
    status=FALSE
fi

if [ ${status:-NOTHING} = TRUE ]
then
    rm -rf ${GAME}
    cd ${DESTDIR}
    unzip ${GAMEZIP}
fi

    
