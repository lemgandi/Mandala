#!/bin/bash


INFILE=$1
OUTFILE=$(basename $1 .mkv).gif

if [ ${INFILE:-NOTHING} = "NOTHING" ]
then
   echo Please pass infile name \( filename.mkv \)
   exit 1
fi

if [ ! -f ${INFILE} ]
then
    echo Oops. No ${INFILE}
    exit 2
fi
echo $INFILE $OUTFILE
set -x
ffmpeg             -i ${INFILE} \
       -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
       -loop 0 ${OUTFILE}
      



