---
title: Vim References
---
A reference guide for commands I find myself forgetting and searching for
constantly.

## General Shortcuts
- 
`<C-[>`
   : Shorthand for escape. Never leave the home row.
- 
`<C-g>`
   : Display status bar with filename

## Text Editing and Movement
- 
`vip`
   : Visual select of paragraph
- 
`gq`
   : Reflow selected text
- 
`=`
   : Reindent visual selected text
- 
`=G`
   : Reindent from cursor to end of file

#### Spelling
- 
`]s` or `[s`
   : Jump to next misspelled word
- 
`z=`
   : Check spelling of word under cursor
- 
`zg`
   : Add word under cursor to dictionary

## Tabs and Splits
- 
`gt` or `gT`
   : Jump to next or previous tab
- 
`sp`
   : Split screen
- 
`vsp`
   : Split Screen vertically
- 
`<C-w> movement`
   : Move to split

## Vim Wiki
Requires _vimwiki_ plugin

- 
`<leader>wt`
   : Open wiki in tab
- 
`gll` or `glh`
   : Increase or decrease indenting for lists
- 
`<C-T>` or `<C-D>`
   : Same thing but in insert mode

#### HTML Conversion
- 
`:VimwikiAllHTML`
   : Converts every page to HTML
- 
`<Leader>wh`
   : convert current page to html
- 
`<Leader>whh`
   : convert current page to html and open in browser

## NerdTree
Requires _NerdTree_ plugin

- 
`<C-n>`
   : Enable NerdTree
   : From here `t` opens up file in new tab

## NerdCommenter
Requires _NerdCommenter_ plugin

- 
`<leader>c<space>`
   : toggles current line comment
- 
`<leader>cA`
   : Adds comment to end of current line
