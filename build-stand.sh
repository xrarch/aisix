#!/bin/bash

path=$(dirname $0)

mkdir -p ${path}/tmp/

./sdk/dragonc.sh ${path}/src/stand/diag/Diag.d ${path}/tmp/diag.a3x
./sdk/dragonc.sh ${path}/src/stand/dskfa/Dskfa.d ${path}/tmp/dskfa.a3x

./sdk/fsutil.sh $1 w /diag.a3x ${path}/tmp/diag.a3x
./sdk/fsutil.sh $1 w /dskfa.a3x ${path}/tmp/dskfa.a3x