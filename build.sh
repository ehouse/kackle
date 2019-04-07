#!/bin/bash
set -euo pipefail

### Required to work on Mac OS.
if [[ $(uname) == "Darwin" ]];then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

# Infile replaces file includes with the files original content

pushd ./src >/dev/null
    # Build array of include locations with linenumbers
    indexes=( $(awk '
        /\. (\.\/lib\/\w)/  { AT[NR]=$2 }
        END                 { for (key in AT) { print key, AT[key] }}
        ' kackle.sh) )

    cp ${1:-kackle.sh} .build.tmp

    for (( idx=${#indexes[@]}-1 ; idx>=0 ; idx-=2 )) ; do
        IFS='%'

        lineno="${indexes[idx-1]}"
        filepath="${indexes[idx]}"

        # Replace file include statements with linked file
        sed -i "${lineno}s/.*/$(sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' $filepath | tr -d '\n')/" .build.tmp
    done
popd >/dev/null

mv src/.build.tmp bin/kackle
