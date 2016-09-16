Title: Vim Cheatsheat for Everyone Else
Date: 2016-03-28
Modified: 2016-04-05
Status: draft
Summary: I'm not a newbie but I'm also not an expert. Sometimes I wish there was a cheatsheet for the weird commands I really need once in a while. 

All of these commands will work on a stock version of Vim excluding those in the
Plugins section. If you are interested in my `.vimrc` you can find it
[here](https://github.com/ehouse/dotfiles). I have 7.3 installed but I'm sure
these shortcuts exist in versions dating back years. 

## Base Shortcuts

### General Shortcuts
- `C-[` - Shorthand for Esc. Extra useful if you have Caps mapped to control. 

### Tabs and Splits
- `gt` OR `gT` - Move to next tab.
- `vsp` OR - Split the screen vertically. 

### Text Editing and Movement 
- `vip` - Visual Select Paragraph.
- `gq` - Reflow selected text.
- `z=` - Check spelling of word under cursor.
- `zg` - Add word to correct word list.
- `]s` OR `[s` - Jump to next or previous misspelled word.
- `=` - Reindent visual selected text.
- `=G` - Reindent from cursor to end of file.

## Plugins Shortcuts
- NerdTree - `C-n` to open up the menu. `t` opens up a file in a new tab and
enter opens it up normally. 
- NerdCommenter - `<leader>c<space>` toggles selected lines and `<leader>cA`
  addes a comment to the end of the line. 
