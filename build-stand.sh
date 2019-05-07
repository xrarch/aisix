#!/bin/bash

path=$(dirname $0)

mkdir -p ${path}/tmp/

./sdk/dragonc.sh ${path}/src/stand/diag/Diag.d ${path}/tmp/diag.stand
./sdk/fsutil.sh $1 w /diag.stand ${path}/tmp/diag.stand