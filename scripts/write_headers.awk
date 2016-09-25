#!/usr/bin/awk -f

BEGIN   { print "---"; FS=";"; OFS="\n" }
        { for(i=1; i<=NF; i++) print $i }
END     { print "---" }
