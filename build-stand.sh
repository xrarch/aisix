#!/bin/bash

diagpath=$(dirname $0)/src/stand/diag
limnvolpath=$(dirname $0)/src/stand/limnvol

make --directory=${diagpath}
make --directory=${limnvolpath}

./sdk/fsutil.sh $1 w /stand/diag ${diagpath}/diag.a3x
./sdk/fsutil.sh $1 w /stand/limnvol ${limnvolpath}/limnvol.a3x