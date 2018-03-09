## Kackle Static Site Generator

Kackle was designed for self reliance. No crazy language stacks to mange, no
software dependencies to track. You shouldn't need 100M of libraries to publish
a blog or website. With Kackle it only depends on languages found on a base
install of OpenBSD.

### Downloading
Head over to the github releases page
[here](https://github.com/ehouse/kackle/releases) to pickup the most recent
release. Checkout the master branch if you're brave ok with things breaking.

### Dependencies
- `gnu-coreutils`: Required for building
- `pandoc`: Compile markdown to html
- `gnu-make`: Required for running Makefile.
- `HTML::Entities`: Optional, ensures web safe filenames
- `HTML::Packer`: Optional, compress outputted HTML

### Setup

Add `kackle/bin` to your path and you're good to go. Run `kackle -s` to create a
skeleton project in the current working directory.

```
[ehouse@myon-2 kackle]$ cd sample
[ehouse@myon-2 sample]$ make
  CREATE index.md -> /Users/ehouse/Projects/kackle/sample/src/blog/index.md
  BUILD src/blog/index.md -> /Users/ehouse/Projects/kackle/sample/out/blog/index.html
  BUILD src/blog/post1.md -> /Users/ehouse/Projects/kackle/sample/out/blog/post1.html
  BUILD src/blog/post2.md -> /Users/ehouse/Projects/kackle/sample/out/blog/post2.html
  BUILD src/blog/post3.md -> /Users/ehouse/Projects/kackle/sample/out/blog/post3.html
  BUILD src/index.md -> /Users/ehouse/Projects/kackle/sample/out/index.html
  COPY ./static/ -> /Users/ehouse/Projects/kackle/sample/out
```

New posts can be created with `kackle -p` command. It will run through a set of
questions to setup a new post.

### Design

Kackle fits two use cases that few other static site generators aim to hit. It's
simple, easily hackable and only offers what you see. No fancy bells or
whistles to distract you from what matters, writing content.

Assuming everything works the first time ;)

### But why?
Not every software project needs a purpose. 
