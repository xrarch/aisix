path=$(dirname $0)

make --directory=${path}/rtaisix

../sdk/install.sh ${path}/rtaisix
