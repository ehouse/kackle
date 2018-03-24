#!/bin/bash
set -euo pipefail

### Required to work on Mac OS.
if [[ $(uname) == "Darwin" ]];then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

. ./lib/config.sh
. ./lib/logging.sh
. ./lib/helpdoc.sh
. ./lib/minify.sh

command -v pandoc >/dev/null 2>&1 \
    || logging::fatal "Pandoc binary not found!"

### R/W Stateful Global Variables
# Current prod build state
PROD=1
# Files/Folder exlude array
EXCLUDE=()

#############################################################
# Runs through set of questions to create a new blog post
#
# Arguments:
#  None
#############################################################
new-post(){
    local -r AWK_HEADERS=\
'BEGIN   { FS=":"; OFS="\n"}
        { printf "---\ntitle: %s\ndate: %s\nauthor: %s\nsummary: %s\n---", $1, $2, $3, "Example Blog Post" }
END     { print "\n\nContent of my super awesome blog post!" }'

    read -p "Name of page: " p_title
    read -p "Location of page [$_config_draft_location]: " p_location
    read -p "Author [$_config_draft_author]: " p_author

    # Sets defaults if given value is NULL
    local -r p_location=${p_location:-$_config_draft_location}
    local -r p_author=${p_author:-$_config_draft_author}
    local -r p_date=$(date +"%B %d, %Y")

    # Normalize file name before writing to disk
    local -r p_ondisk=$(echo "$p_title" \
        | tr " " - \
        | tr '[:upper:]' '[:lower:]' \
        | perl -p -e  's/[^A-Za-z0-9\-\.]//g;')

    # Ensures html safe encodings are used for rendered metadata
    local -r p_title=$(echo "$p_title" \
        | perl -n -mHTML::Entities -e ' ; print HTML::Entities::encode_entities($_) ;')

    local -r p_file="$p_location/$p_ondisk.md"

    if [[ ! -d $(dirname "$p_file") ]];then
        printf "Folder %s doesn't exist. Can't Create %s\n" "$(pwd)/$(dirname $p_file)" "$p_file"
        exit 1
    fi

    # Writes out template for new blog post
    echo "$p_title:$p_date:$p_author" \
        | awk "$AWK_HEADERS" \
        >> "$p_file"

    echo "File $(readlink -f "$p_file") Created Successfully"
}


##########################################
# Generates skeleton project folder
#
# Arguments:
#  None
##########################################
copy-skel() {
    printf "  Creating Skeleton Project"
    cp -r $(dirname $(dirname "$0"))/skel/* $(pwd)/
}

########################################################
# Compile individual markdown file
#   Won't build if output,theme same age as input.
#   Makes no assumptions, all arguments required.
#
# Arguments:
#   Input File path
#   Output File path
#   Theme File path
########################################################
build-file() {
    local -r IN=$1
    local -r OUT=$2
    local -r THEME=$3

    if [[ ! -d "$(dirname $OUT)" ]]; then
        mkdir -p "$(dirname $OUT)"
    fi

    if [[ "$IN" -nt "$OUT" ]] || [[ "$THEME" -nt "$OUT" ]]; then
        pandoc --template "$THEME" -f markdown -o "$OUT" < "$IN"
        printf "  BUILD %s -> %s\n" "$IN" "$(readlink -f $OUT)"
    fi
}

#######################################################
# Loop over folder building all its content
#   Dummy Wrapper around build-file
#
# Arguments:
#   Source folder to be built
#   Output folder
#   Theme file to use
#######################################################
build-folder() {
    local -r SRC=$1
    local -r OUT=$2
    local -r THEME=$3

    local -r MD_FILES=($(find -L "$SRC" -name "*.md"))
    local -r BLD_FILES=($(sed "s@src@${OUT}@g;s@.md@.html@g" <<< "${MD_FILES[@]}"))

    local i
    local a

    for ((i=0; i<${#BLD_FILES[@]};++i)); do
        # If file is excluded then skip
        for a in ${EXCLUDE[@]:-}; do
            if [[ ${BLD_FILES[i]} =~ $a ]]; then
                continue 2
            fi
        done
        build-file "${MD_FILES[i]}" "${BLD_FILES[i]}" "$THEME"
    done

    local -r PROJECT_DEST=$(sed "s/src/out/g" <<< "$SRC")

    rsync -qrvzcl --delete "./static/"* "$PROJECT_DEST"
    printf "  COPY %s -> %s\n" "./static/" "$(readlink -f $PROJECT_DEST)"
}

##########################################################
# Create pseudo YAML header from supplied argument array
#
# Arguments:
#  Array of strings
##########################################################
format-page() {
    echo -e "---"
    for i in "$@";do
        echo -e "$i"
    done
    echo -e "---\n"
}

#####################################################
# Extract YAML headers from file
#
# Arguments:
#   Path to file
# Returns:
#   Prints formatted YAML to STDOUT
#####################################################
extract-headers(){
    awk -F ':' \
    '/title:/    { title = $2 }
    /author:/   { author = $2 }
    /date:/     { ("date +\"%B %d, %Y\" -d\x27"$2"\x27" | getline date) }
    /summary:/  { summary = $2 }

    END         { printf "%s:%s:%s:%s:%s\n", date, title, author, summary, FILENAME }' $1
}

#######################################################
# Create blogroll index of a folder
#   Requires properly formatted YAML headers
#
# Arguments:
#   Source folder to build
#######################################################
create-blogroll() {
    local -r SRC="$1"
    local -r TITLE="$3"
    local -r AWK_HTML=\
'{ gsub(".md",".html");
printf "<article class=\"post\">\n"
printf "<h4 class=\"post-title\"><a href=/%s>%s</a></h4>\n", $5, $2

printf "<ul class=\"post-header\">"
if ($3)
    printf "<li class=\"post-author\">Written by %s</li>", $3
if ($1)
    printf "<li class=\"post-date\"><time>Posted on %s</time></li>", $1
printf "</ul>\n"

if ($4)
    printf "<p class=\"post-summary\">%s</p>\n", $4
printf "</article>\n\n"}'

    ### Create a temporary file to work with
    local -r TMPFILE=$(mktemp)
    local f
    local a

    ### Blow away previously created blogroll index
    rm -f "$SRC/index.md"
    format-page "title: $TITLE" > "$TMPFILE"
    for f in "$SRC"/*.md;do
        # If file is excluded then skip
        for a in ${EXCLUDE[@]:-}; do
            if [[ $i =~ $f ]]; then
                continue 2
            fi
        done
        ### Extract the headers from working file
        extract-headers "$f"
    done | sort -k3nr -k1Mr -k2nr \
        | sed "s@$(dirname $SRC)/@@g" \
        | awk -F ':' "$AWK_HTML" \
        >> "$TMPFILE"
    ### This fancy bit of logic above sorts the resulting articles by time descending order
    ### Then removes the directory name in the links
    ### Finally applies the AWK_HTML logic

    cp "$TMPFILE" "$SRC/index.md"
    printf "  CREATE index.md -> %s\n" "$(readlink -f $SRC/index.md)"
}

########################################################################################
# Finalize output directory for deployment to production type servers
#   If -t is set then robots.txt blocks entire site and nothing is compressed.
#   else robots.txt blocks /drafts and everything is compressed using htmlcompressor.
#
# Arguments:
#   Source folder to compress
#   Sitename for sitemap.xml
########################################################################################
finalize-webdir() {
    local -r TARGET=$1
    local -r SITENAME=$2
    local -r AWK_SCRIPT=\
'BEGIN { print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"\
        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
        xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9\
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">" }
    { printf "\t<url>\n\t\t<loc>%s</loc>\n\t\t<changefreq>weekly</changefreq>\n\t</url>\n", $NF }
END { print "</urlset>"}'

    local -r BLD_FILES=($(find -L "$TARGET" -name "*.html"))
    local i # Index for BLD_FILES
    local fd # Local file descriptor

    for i in ${BLD_FILES[@]:-}; do
        # If file is excluded then skip
        for a in ${EXCLUDE[@]:-}; do
            if [[ $i =~ $a ]]; then
                continue 2
            fi
        done
        fd=$(echo $i \
            | sed "s@$TARGET/@https://$SITENAME/@g")
        echo "$fd"
    done | awk -F"\n" "$AWK_SCRIPT" \
        > "$TARGET/sitemap.xml"

    printf "  CREATE sitemap.xml -> %s\n" "$(readlink -f $TARGET/sitemap.xml)"

    if [[ "$PROD" ]] ;then
        echo -e "User-Agent: *\nDisallow: /drafts/" > "$TARGET/robots.txt"
        printf "  CREATE PROD robots.txt -> %s\n" "$(readlink -f $TARGET/robots.txt)"
    else
        echo -e "User-Agent: *\nDisallow: /" > "$TARGET/robots.txt"
        printf "  CREATE DEV robots.txt -> %s\n" "$(readlink -f $TARGET/robots.txt)"
    fi

    if [[ "$PROD" ]] && [[ "$_config_minimize_files" ]];then
        printf "  MINIFYING directory %s*/(*.html|*.css)\n" "$TARGET"
        find -L "$TARGET" \( -name "*.html" -or -name "*.css" \)|while read -r fname; do
            minify::file "$fname"
        done
    fi
}

main() {
    while getopts ":hvdpo:b:r:tT:N:x:f:e:s" opt; do
        case $opt in
            p)
                new-post
                exit 0
                ;;
            h)
                # Print Usage
                usage "long"
                exit 0
                ;;
            v)
                # Verbose Mode
                set -v
                ;;
            d)
                # Debug Mode
                set -x
                ;;
            t)
                # Set prod state
                PROD=0
                ;;
            o)
                # Override default output folder
                local -r OUTPUT_O="$OPTARG"
                ;;
            e)
                # Set Theme
                local -r THEME_O="$OPTARG"
                ;;
            f)
                # Finalize folder for deployment
                local -r TASK="f"
                local -r TARGET=$OPTARG
                ;;
            b)
                # Build Folder
                local -r TASK="b"
                local -r TARGET=$OPTARG
                ;;
            r)
                # Create Blogroll
                local -r TASK="r"
                local -r TARGET=$OPTARG
                ;;
            s)
                # Create skeleton project
                copy-skel
                exit 0
                ;;
            T)
                # Set title for blogroll
                local -r BLOGROLL_TITLE="$OPTARG"
                ;;
            N)
                # Set sitename for Sitemap Generator
                local -r SITENAME="$OPTARG"
                ;;
            x)
                # Exclude folder from build process
                EXCLUDE+=( $OPTARG )
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                usage
                exit 1
                ;;
        esac
    done

    # Print Usage if no build command provided
    if [[ -z ${TASK:-} ]]; then
        usage
        exit
    fi

    ### SET DEFAULTS AND READONLY STATUS
    local -r OUTPUT=${OUTPUT_O:-"out/"}
    local -r THEME=${THEME_O:-"./theme/base.html"}

    # Test if target is a folder
    if ! [[ -d $TARGET ]]; then
        echo "$TARGET must be a folder"
        exit 1
    fi

    # Run Build Commands
    if [[ ${TASK:-} == "b" ]]; then
        build-folder "$TARGET" "$OUTPUT" "$THEME"

    elif [[ ${TASK:-} == 'r' ]]; then
        create-blogroll "$TARGET" "$OUTPUT" "${BLOGROLL_TITLE:-Blog Posts}"

    elif [[ ${TASK:-} == 'f' ]]; then
        if [[ -z ${SITENAME:-} ]];then
            echo "Sitename required for finalization"
            exit 1
        fi
        finalize-webdir "$TARGET" "$SITENAME"
    fi
}

main "$@"
