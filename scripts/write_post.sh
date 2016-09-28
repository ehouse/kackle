#!/bin/bash -e

### Creates new post asking questions as it runs

default_location="drafts"
default_author="Ethan House"

read -p "Name of page: " p_title
read -p "Location of page [$default_location]: " p_location
read -p "Author [$default_author]: " p_author

# Sets defaults if given value is NULL
p_location=${p_location:-$default_location}
p_author=${p_author:-$default_author}
p_date=$(gdate +"%d %B, %Y")

# Ensures no illegal/bad characters are written to disk
p_ondisk=$(echo $p_title | tr " " - | tr '[:upper:]' '[:lower:]' | perl -pi -e  's/[^A-Za-z0-9\-\.]//g;')

# Ensures html safe encodings are used
p_title=$(echo $p_title | perl -n -mHTML::Entities -e ' ; print HTML::Entities::encode_entities($_) ;')

# Writes out template for new blog post
echo "$p_title:$p_date:$p_author" | awk \
    'BEGIN  {FS=":"; OFS="\n"}
            { print "---"; print "title: "$1, "date: "$2, "author: "$3; print "---" }
    END     { print "\nContent of my super awesome blog post!" }' >> src/$p_location/$p_ondisk.md

echo "File $(pwd)/src/$p_location/$p_ondisk.md Created Successfully"
