#!/usr/bin/awk -f

### Parses file for yaml data. Returns that data in an easily parsable format.

BEGIN       { FS=": " }

/title:/    { title = $2 }
/author:/   { author = $2 }
/date:/     { ("gdate +\"%B %d, %Y\" -d'"$2"'" | getline date) }
/summary:/  { summary = $2 }

END         { printf "%s:%s:%s:%s:%s\n", date, title, author, summary, FILENAME }
