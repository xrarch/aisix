#!/bin/bash

mkpath=$(dirname $0)/src/sys/microkernel

make --directory=${mkpath}

./sdk/fsutil.sh $1 w /aisix ${mkpath}/aisix