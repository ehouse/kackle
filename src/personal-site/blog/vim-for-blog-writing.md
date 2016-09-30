---
title: Vim for Blog Writing
author: Ethan House
date: November 19, 2015
summary: Quite a lot of issues I had writing blog posts in Vim were solved with a few config edits.
---

For a while I was using IDE's like Atom or Sublime to write my blog posts but I
found it annoying to switch between the terminal and the IDE constantly. The
two things I needed were working syntax highlighting and spell checking so a full
IDE was overkill. 

### Markdown Syntax Highlighting

I was having issues having Vim understand the syntax of my .md files so I had
to add a special rule to treat them as such. It treats all files ending in .md
as markdown but that works for me. Add the line to your .vimrc and you're set. 

    au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

### Spell Check

First add this `set spelllang=en_us` to your .vimrc file. This sets the
language the spell checker will use. When you want to start the spell checker
type `:set spell` and to disabled it `:set nospell`. Pretty easy to remember.

Assuming there are actually misspellings in your article words will get
highlighted red. The `[s` and `]s` commands are used to jump backwards and
forwards to the next misspelled words. Use `z=` to correct the word under the
cursor and use `zg` to add the word to the local dictionary. 
