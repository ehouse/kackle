#####
# Print Usage Documents, either short or long
# Arguments:
#   If variable $1 is set, print long help
#####
usage(){
    cat <<- EOM
USAGE: [-vhd] -b TARGET [-e THEME.html] [-o OUTPUT]
              -r TARGET [-T TITLE] [-o OUTPUT]
              -f SRC [-t] [-N SITENAME] [-x FOLDER] [-o OUTPUT]
EOM
if [[ -z ${1:-} ]];then
    return
fi
cat <<- EOM

Content Generation
 -b folder : Build target folder
 -r folder : Build blogroll of target folder
 -f folder : Finalize folder for deployment by writing out robots.txt, sitemap.xml, and compresses folder
 -p        : Creates new post based on defaults and user answers
 -s        : Creates skeleton kackle project

Content Generators Options
 -N title  : Sitename for sitemap generator
 -T title  : Set title for blogroll
 -t        : Test settings for -f flag. Disables compression and restrictive robots.txt
 -x regex  : Excludes files or folder using greedy regex. Flag can be repeated

Input/Output Settings
 -o folder : Set output folder (Default: out/)
 -e file   : Set theme file (Default: theme/base.html)

Usage and Debug
 -h        : Show help menu
 -v        : Set Verbose
 -d        : Set Bash debug mode
EOM
}
