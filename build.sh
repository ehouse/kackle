#!/bin/bash

# Infile replaces file includes with the files original content

cd src

# Build array of include locations with linenumbers
indexes=( $(awk '
    /\. (\.\/lib\/\w)/  { AT[NR]=$2 }
    END                 { for (key in AT) { print key, AT[key] }}
    ' kackle.sh) )

cp ${1:-kackle.sh} inprocess.sh

for (( idx=${#indexes[@]}-1 ; idx>=0 ; idx-=2 )) ; do
    IFS='%'

    lineno="${indexes[idx-1]}"
    filepath="${indexes[idx]}"

    # Replace file include statments with linked file
    sed -i "${lineno}s/.*/$(sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' $filepath | tr -d '\n')/" inprocess.sh
done

cd ../

mv src/inprocess.sh bin/kackle
