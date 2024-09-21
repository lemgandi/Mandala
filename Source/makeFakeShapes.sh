#!/bin/bash

#Simple shell script to set up for testing editConfiguration.lua


SHAPEDIR=Images/shapes
RESERVEDIR=${SHAPEDIR}/reserve

set -x
mkdir ${RESERVEDIR}
mv ${SHAPEDIR}/*.png ${RESERVEDIR}

cp ${RESERVEDIR}/Line.png ${SHAPEDIR}

for kk in 02 03 04 05 06 07 08 09 10
do
    cp ${SHAPEDIR}/Line.png  ${SHAPEDIR}/Line$kk.png
done
