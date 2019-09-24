#!/bin/bash

path=$(dirname $0)

mkdir -p ${path}/tmp/

./sdk/dragonc.sh -flat ${path}/src/sys/kernel/Aisix.d ${path}/tmp/aisix

./sdk/fsutil.sh $1 w /aisix ${path}/tmp/aisix
