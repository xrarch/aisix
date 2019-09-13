#!/bin/bash

path=$(dirname $0)

mkdir -p ${path}/tmp/

./sdk/dragonc-flat.sh ${path}/src/sys/kernel/Aisix.d ${path}/tmp/aisix

./sdk/fsutil.sh $1 w /aisix ${path}/tmp/aisix
