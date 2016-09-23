#!/usr/bin/awk -f

# Parses file for yaml data. Returns that data in an easily parsable format.

BEGIN       { FS=": "; print ARGV[1]; }

/title:/    { title = $2 }
/date:/     { ("gdate +\"%d %B %Y\" -d'"$2"'" | getline date) }
/summary:/  { summary = $2 }

END         { printf "%s:%s:%s\n", date, title, summary }
