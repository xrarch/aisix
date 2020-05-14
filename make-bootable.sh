#!/bin/bash

path=$(dirname $0)/src/stand/boot

make --directory=${path}

dd if=${path}/BootSector.bin of=$1 bs=4096 conv=notrunc seek=1
dd if=${path}/loader.a3x of=$1 bs=4096 conv=notrunc seek=2