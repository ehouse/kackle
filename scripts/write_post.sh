#!/bin/bash -e

### Creates new post asking questions as it runs

default_project="blog"
default_location="drafts"
default_author="Ethan House"

read -p "Name of page: " p_title
read -p "Location of page [$default_location]: " p_location
read -p "Project [$default_project]: " p_project
read -p "Author [$default_author]: " p_author

# Sets defaults if given value is NULL
p_location=${p_location:-$default_location}
p_author=${p_author:-$default_author}
p_project=${p_project:-$default_project}
p_date=$(gdate +"%B %d, %Y")

# Ensures no illegal/bad characters are written to disk
p_ondisk=$(echo $p_title | tr " " - | tr '[:upper:]' '[:lower:]' | perl -p -e  's/[^A-Za-z0-9\-\.]//g;')

# Ensures html safe encodings are used
p_title=$(echo $p_title | perl -n -mHTML::Entities -e ' ; print HTML::Entities::encode_entities($_) ;')

p_file="src/$p_project/$p_location/$p_ondisk.md"

# Writes out template for new blog post
echo "$p_title:$p_date:$p_author" | awk \
    'BEGIN  {FS=":"; OFS="\n"}
            { printf "---\ntitle: %s\ndate: %s\nauthor: %s\nsummary: %s\n---", $1, $2, $3, "Example Blog Post" }
    END     { print "\nContent of my super awesome blog post!" }' >> $p_file

echo "File $(pwd)/$p_file Created Successfully"
