#! /bin/bash

# Copy game to machine for assets testing etx
# Charles Shapiro 11 Oct 2024

DESTDIR=/media/devel/PLAYDATE/Games/User
status=TRUE
GAMESRCDIR=${HOME}/Playdate_src/Mandala
GAMEZIP=${GAMESRCDIR}/Mandala.zip
GAME=${DESTDIR}/Mandala.pdx

if [ ! -d ${GAME} ]
then
    echo Oops. Must connect playdate
    status=FALSE
fi

if [ ${status:-NOTHING} = TRUE ]
then
    rm -rf ${GAME}
    pushd ${GAMESRCDIR}
    cd ${DESTDIR}
    unzip ${GAMEZIP}
    popd
fi

    
