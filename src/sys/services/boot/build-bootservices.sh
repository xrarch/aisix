bootservicespath=$(dirname $0)

for d in ${bootservicespath}/*/ ; do
    make --directory=${d}
done