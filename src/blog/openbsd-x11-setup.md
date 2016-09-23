---
title: OpenBSD X11 Setup
author: Ethan House
date: September 9, 2013
summary: My personal working setup for my OpenBSD laptop running on my Thinkpad x230. All of this can also be found on my [Github](https&#58;//github.com/ehouse/dotfiles).
---

This is my personal setup for my openbsd laptop. I use i3 as my window manager
and i3lock as a screen lock daemon.

### xinitrc

``` bash
xmodmap -e 'remove Lock = Caps\_Lock'
xmodmap -e 'keysym Caps\_Lock = Control\_L'
xmodmap -e 'add Control = Control\_L'
```

I personally believe the home row is far to important for a caps lock
key. So I remap it to left control. Makes bash and vim commands easier
to type. I found the easiest program to use was xmodmap. Just keep in
mind that in single user mode these settings will not take effect as X11
is never started.

``` bash
export LANG="en\_US.UTF-8"
export MM\_CHARSET="UTF-8"
```

I had issues with i3 overwriting locale settings. The solution was to
set them in xinit instead of zshrc.

```
LOCK="i3lock -i /home/ehouse/Pictures/Wallpapers/lockscreen.png"
xautolock -locker "\$LOCK" -nowlock "\$LOCK" &
```

I was playing around with slimlock originally but it is incompatible
with FreeBSD. It requires specific libraries only available in the Linux
kernel. Instead I decided to use i3lock and xautolock. Simple, but works
well.

### i3/config

I am only going to include code that wasn't auto generated.

``` bash
# start a terminal
bindsym \$mod+Return exec sakura

# Screen Lock
bindsym \$mod+q exec "xautolock -locknow"
```

Instead of relying on i3-sensible-terminal I just wrote in sakura. It is
gtk based terminal that doesn't have an incredible dependency list like
terminator or roxterm. I set a shortcut for locking the display.
Xautolock and i3lock both support suspend and lock but I haven't played
around with it yet. I chose meta+q as it was not something I would
accidentally hit.

``` bash
exec --no-startup-id nitrogen –restore
```

nitrogen works very well for setting X wallpapers. It requires that you
start nitrogen and manually set the wallpaper though. It doesn't support
sideshow wallpapers but it probably wouldn't be too hard to write a
cronjob to do that.

I also remapped all of the movement keys over one to be more vimlike. I
use G and V for horizontal and vertical splits. As much as I understand
why they didn't go with hjkl I don't want to relearn the land positions.
And finally I used i3menu for the menu bar. It comes with i3 and it is
very easy to configure. It doesn't put much load on the system when
polling which is always a plus. Laptop battery life is precious.

That is my X11 setup in a nutshell. If anyone is interested in how I got
something to work don't hesitate and throw me an email. I always enjoy a
good technical conversation.
