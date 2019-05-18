#!/bin/bash

path=$(dirname $0)

mkdir -p ${path}/tmp/

./sdk/asm.sh ${path}/src/sys/boot/BootSector.s ${path}/tmp/BootSector.bin
./sdk/dragonc.sh ${path}/src/sys/boot/Main.d ${path}/tmp/loader.bin

dd if=${path}/tmp/BootSector.bin of=$1 bs=4096 conv=notrunc seek=1
dd if=${path}/tmp/loader.bin of=$1 bs=4096 conv=notrunc seek=2