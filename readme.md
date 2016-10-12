## Kackle Static Site Generator

Kackle was designed to be simple and easily extendible. It came from a desire to
have a configurationless site generator not reliant on huge languages or their
dependencies. Kackle only requires libraries anyone is going to have laying
around their Linux/\*BSD system.

**Warning** I've only ever tested this on my laptop. Your millage may vary.

### Downloading
Head over to the github releases page
[here](https://github.com/ehouse/kackle/releases) to pickup the most recent
release. Checkout the master branch if you're brave ok with things breaking.

### Dependencies
- `gnu-coreutils`: Required for building.
- `pandoc`: Compilg markdown to html.
- `gnu-make`: Required for running Makefile.
- `rsync`: Used for deploying but could be replaced with anything.
- `htmlcompressor`: Very optional, easily disabled in Makefile. Used for minifying html and css.

### Setup

Kackle treats all folders in `src/` as individual projects. Kackle defaults to
`theme/base.html` as the theme to build with within each project. In addition
all folders within `static/` will be copied to the output folder. All markdown
files will be compiled and placed in the output folder which defaults to `out/`
and with their paths maintained.

Building and deploying the sample project would look like...

```bash
[ehouse@myon kackle]$ make deploy
# Build Blogroll index
 CREATE index.md -> /Users/ehouse/Projects/kackle/src/sample/blog/index.md
# Build Blog
 BUILD src/sample/blog/index.md -> /Users/ehouse/Projects/kackle/out/sample/blog/index.html
 BUILD src/sample/blog/post1.md -> /Users/ehouse/Projects/kackle/out/sample/blog/post1.html
 BUILD src/sample/blog/post2.md -> /Users/ehouse/Projects/kackle/out/sample/blog/post2.html
 BUILD src/sample/blog/post3.md -> /Users/ehouse/Projects/kackle/out/sample/blog/post3.html
 BUILD src/sample/index.md -> /Users/ehouse/Projects/kackle/out/sample/index.html
 COPY src/sample/static/ -> /Users/ehouse/Projects/kackle/out/sample
 CREATE DEV robots.txt -> /Users/ehouse/Projects/kackle/out/sample/robots.txt
# Create sitemap
 CREATE sitemap.xml -> /Users/ehouse/Projects/kackle/out/sample/sitemap.xml
# Compress the CSS, HTML and JS
find -L out/sample \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;
rsync -e ssh -P -rvzcl --delete out/sample/ bawls.ehouse.io:/home/ehouse/public_html/webtest --cvs-exclude
building file list ...
15 files to consider
index.html
        1898 100%    0.00kB/s    0:00:00 (xfer#1, to-check=13/15)
blog/index.html
        2220 100%    2.12MB/s    0:00:00 (xfer#2, to-check=9/15)
blog/post1.html
        1693 100%    1.61MB/s    0:00:00 (xfer#3, to-check=8/15)
blog/post2.html
        2379 100%    2.27MB/s    0:00:00 (xfer#4, to-check=7/15)
blog/post3.html
        2378 100%    2.27MB/s    0:00:00 (xfer#5, to-check=6/15)
css/custom.css
         216 100%  210.94kB/s    0:00:00 (xfer#6, to-check=4/15)
css/normalize.css
        7439 100%    3.55MB/s    0:00:00 (xfer#7, to-check=3/15)
css/skeleton.css
       10623 100%    3.38MB/s    0:00:00 (xfer#8, to-check=2/15)

sent 11037 bytes  received 550 bytes  7724.67 bytes/sec
total size is 30804  speedup is 2.66
```

### Design

Kackle fits two use cases that few other static site generators aim to hit. It's
simple, easily hackable and only offers what you see. No fancy bells or
whistles to distract you from what matters, writing content.

Assuming everything works the first time ;) 

### Hacking

The Makefile is purely a wrapper around the kackle shell script within the
`scripts/` folder. The following command will manually build a folder with a given
template and place it in the `./out` folder.

``` bash
./scripts/kackle -b src/sample -o ./out -t ./src/sample/theme/base.html
```
