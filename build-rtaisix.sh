path=$(dirname $0)

make -C ${path}/rtaisix

../sdk/install.sh ${path}/rtaisix
