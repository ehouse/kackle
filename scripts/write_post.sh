#!/bin/bash -e

default_location="drafts"
default_author="Ethan House"

read -p "Name of page: " p_title
read -p "Location of page [$default_location]: " p_location
read -p "Author [$default_author]: " p_author

p_location=${p_location:-$default_location}
p_author=${p_author:-$default_author}
p_date=$(gdate +"%d %B, %Y")

p_ondisk=$(echo $p_title | tr " " - | tr '[:upper:]' '[:lower:]')
p_title=$(echo $p_title | perl -n -mHTML::Entities -e ' ; print HTML::Entities::encode_entities($_) ;')

echo "$p_title:$p_date:$p_author" | awk \
    'BEGIN  {FS=":"; OFS="\n"}
            { print "---"; print "title: "$1, "date: "$2, "author: "$3; print "---" }
    END     { print "\nContent of my super awesome blog post!" }' >> src/$p_location/$p_ondisk.md

echo "File $(pwd)/src/$p_location/$p_ondisk.md Created Successfully"
