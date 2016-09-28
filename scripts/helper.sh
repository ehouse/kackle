#!/bin/bash

function write_header {
    echo $@ | ../../scripts/write_headers.awk
}

# Gathers file data from a directory
function extract_directory {
    for f in *.md
    do
        #data=`cat $f | ../../scripts/extract_headers.awk`
        ../../scripts/extract_headers.awk $f
        #echo $data:$f
    done
}

function sort_dir {
    extract_directory | gsort -k3nr -k2Mr -k1nr
}

function write_blogroll {
    sort_dir | awk -F ':' \
    '{ gsub(".md",".html");
    printf "<h4 class=\"blog-roll\"> [%s](./%s) </h4>\n", $2, $4
    printf "<p class=\"date\">Written on %s by Ethan House</p>\n\n", $1
    if ($3)
        printf "%s\n\n", $3
    print "---\n"}'
}
