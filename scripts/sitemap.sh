#!/bin/bash -e

### Generates sitemap from all html files in out/ folder

find out -name "*.html" | sed "s/out\//https:\/\/$1\//" | awk -F"\n" \
    'BEGIN { print \
"<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" \
        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \
        xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9 \
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">" }
    { printf "<url>\n\t<loc>%s</loc>\n\t<changefreq>weekly</changefreq>\n</url>\n", $NF }
    END { print "</urlset>"}'
