## Kackle Static Site Generator

Kackle was designed to be simple and easily extendible. It came from a desire to
have a configurationless site generator not reliant on huge languages or their
dependencies. Kackle only requires libraries anyone is going to have laying
around their Linux/\*BSD system.

**Warning** I've only ever tested this on my laptop. Your millage may vary.

### Setup

It's easily setup with a few bash commands and git.

``` bash
git clone https://github.com/ehouse/kackle my-site
```

Any folder within `src/` that contains a `theme/` folder will be treated as a
separate project. Kackle looks for a `theme/base.html` to use as the theme for
the project. All markdown files will be compiled and placed in `/out` with their
paths maintained. All files within a `/static` folder will be copied over
verbatim with `/static` removed.

A very simple build of the sample website would look like...

``` bash
[~/my-site]$ make
 BUILD src/sample/index.md -> out/sample/index.html
 BUILD src/sample/posts/index.md -> out/sample/posts/index.html
 COPY src/sample/static/ -> out/sample
 CREATE DEV robots.txt -> out/sample/robots.txt
 CREATE sitemap.xml -> out/sample/sitemap.xml
```

To serve the files locally run `make devserver`. 

### Design

Kackle fits two use cases that few other static site generators aim to hit. It's
simple, easily hackable and only offers what you see. No fancy bells or
whistles to distract you from what matters, writing content.

### Hacking

The Makefile is purely a wrapper around the kackle shell script within the
`scripts/` folder. The following command will manually build a folder with a given
template and output to `./output`.

``` bash
./scripts/kackle ./template ./src -o ./out
```

Within the `scripts/` folder lives two files called `prebuild.sh` and
`postbuild.sh`. These files will run before and after the build process
respectively when built through the makefile.

### Releases
v0.1-prerelease :: Decoupled persona site from Kackle. Ready for common use.
