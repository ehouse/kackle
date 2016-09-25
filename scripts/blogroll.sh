#!/bin/bash -e

SRC=src/blog
OUTPUT=index.md
TMPFILE=`mktemp`

. ./scripts/helper.sh

cd $SRC

rm -f $OUTPUT

write_header "title: Blog Posts" > $TMPFILE

write_blogroll >> $TMPFILE

cp $TMPFILE $OUTPUT
