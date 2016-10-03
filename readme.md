## Kackle Static Site Generator

Kackle was designed to be simple and easily extendible. It came from a desire to
have a configurationless site generator not reliant on huge languages or their
dependencies. Kackle only requires libraries anyone is going to have laying
around their Linux/\*BSD system.

### Setup

It's easily setup with a few bash commands and git.

``` bash
git clone https://github.com/ehouse/kackle my-site
```

Any folder within `src/` that contains a theme folder will be treated as a
separate project. Kackle looks for a `theme/base.html` to use as the theme for
the project. All markdown files will be compiled and placed in `/out` with their
paths maintained. All files within a `/static` folder will be copied over
verbatim with `/static` removed.

A very simple build would look like...

```
[~/my-site]$ make
 BUILD src/blog/index.md -> out/blog/index.html
 COPY src/blog/static/css -> out/blog/css
 CREATE DEV robots.txt -> out/robots.txt
 CREATE sitemap.xml -> out/sitemap.xml
```

### Design

### Hacking

### License
