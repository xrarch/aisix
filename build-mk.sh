#!/bin/bash

mkpath=$(dirname $0)/src/sys/microkernel

${mkpath}/../services/build-services.sh

make --directory=${mkpath}

./sdk/fsutil.sh $1 w /aisix ${mkpath}/aisix