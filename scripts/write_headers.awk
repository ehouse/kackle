#!/usr/bin/awk -f

### Breaks ; seperated data into properly formatted yaml headers

BEGIN   { print "---"; FS=";"; OFS="\n" }
        { for(i=1; i<=NF; i++) print $i }
END     { print "---" }
