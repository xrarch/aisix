#!/bin/bash

diagpath=$(dirname $0)/src/sys/stand/diag
dskfapath=$(dirname $0)/src/sys/stand/dskfa

make --directory=${diagpath}
make --directory=${dskfapath}

./sdk/fsutil.sh $1 w /stand/diag ${diagpath}/diag.a3x
./sdk/fsutil.sh $1 w /stand/dskfa ${dskfapath}/dskfa.a3x