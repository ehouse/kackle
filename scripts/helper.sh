#!/bin/bash

### Helper Functions for kackle

# Separates headers by ; and prints yaml
function write_header {
    echo $@ | ../../scripts/write_headers.awk
}

# Walks directory extracting yaml header information
function extract_directory {
    for f in *.md
    do
        ../../scripts/extract_headers.awk $f
    done
}

# Sorts files by date attribute by year, month, date
function sort_dir {
    extract_directory | gsort -k3nr -k2Mr -k1nr
}

# Creates blogroll from date sorted directory
function write_blogroll {
    sort_dir | awk -F ':' \
    '{ gsub(".md",".html");
    printf "<h4 class=\"blog-roll\"> [%s](./%s) </h4>\n", $2, $4
    printf "<p class=\"date\">Written on %s by Ethan House</p>\n\n", $1
    if ($3)
        printf "%s\n\n", $3
    print "---\n"}'
}
