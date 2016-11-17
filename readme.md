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
- `pandoc`: Compile markdown to html.
- `gnu-make`: Required for running Makefile.
- `rsync`: Used for deploying but could be replaced with anything.
- `htmlcompressor`: Very optional, easily disabled in Makefile. Used for minifying html and css.

### Setup

Add `export PATH=$PATH:$HOME/Projects/kackle/scripts` to your zshrc or bashrc
file. Replace `/Projects/kackle/bin` with the location of the project on
your machine.

```
[ehouse@myon-2 kackle]$ cd sample
[ehouse@myon-2 sample]$ make
# Build Blogroll index
 CREATE index.md -> /Users/ehouse/Projects/kackle/sample/src/blog/index.md
# Build Blog
 BUILD src/blog/index.md -> /Users/ehouse/Projects/kackle/sample/out/blog/index.html
 BUILD src/blog/post1.md -> /Users/ehouse/Projects/kackle/sample/out/blog/post1.html
 BUILD src/blog/post2.md -> /Users/ehouse/Projects/kackle/sample/out/blog/post2.html
 BUILD src/blog/post3.md -> /Users/ehouse/Projects/kackle/sample/out/blog/post3.html
 BUILD src/index.md -> /Users/ehouse/Projects/kackle/sample/out/index.html
 COPY ./static/ -> /Users/ehouse/Projects/kackle/sample/out
```

### Design

Kackle fits two use cases that few other static site generators aim to hit. It's
simple, easily hackable and only offers what you see. No fancy bells or
whistles to distract you from what matters, writing content.

Assuming everything works the first time ;)

### Hacking

The Makefile in sample is purely a wrapper around the kackle shell script
within the `scripts/` folder. The following command will manually build a
folder with a given template and place it in the `./out` folder.

``` bash
kackle -b src/sample -o ./out -t ./src/sample/theme/base.html
```
