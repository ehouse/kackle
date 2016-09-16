---
title: Adventure Into PCBSD
author: Ethan House
date: September 9, 2015
---

While popping around the BSD community I keep hearing about PCBSD.
Most people seem to detest it but some people like it. PCBSD calls itself a “...
user friendly desktop Operating System based on FreeBSD.” I wasn't quite
sure about the “user friendly” part but I am going to give it a shot.

I wanted a backup of my SSD in the likely chance that I dislike/break it
and want out. The solution came in the form of
[dump](http://www.freebsd.org/cgi/man.cgi?query=dump&sektion=8) and
[restore](http://www.freebsd.org/cgi/man.cgi?query=restore). Incremental
backups of the file system, perfect. Had I known more when I setup the
system I would've used ZFS which contains its own utility for
incremental backups. I booted into single user mode and mounted the
filesystem in read only mode.

	newfs -U /dev/da0
	mount /dev/da0 /mnt/usb
	dump -C16 -b64 -0a -h0 -f /mnt/flashdrive/root.dump /dev/ada0

This took about 10 minutes and I was off installing PCBSD. My first
impressions of the installer were “ohhhh... Pretty”. The entire process
of installing is done within what looks like a KDE environment. While
superfluous, it worked pretty well and I had the system setup in no
time. I thought it was cool that you could pick from a list of window
managers to come pre-installed on the system that included i3, my
personal favorite. Installation was done and it was time to reboot and
initiate first bootup which comes with it's own slew of setup steps.

Nothing, it dropped into the bootup sequence and the screen went black.
I reboot and tried again. Still nothing. Given no chance to boot in
single user mode I didn't see many options. I re-installed the system
this time choosing only defaults. First boot up and still a black
screen. I searched in vain for any way to drop into a shell during the
PCBSD install.

I dropped into a FreeBSD live session and tried to mount the SSD. I
futzed around with the boot settings trying to find a combo that would
produce a bootable system. All I managed to do was mess up the boot
sequence. Getting frustrated I decided to call it a night.

I checked the wiki and saw that my laptop was not on the list of laptops
compatible with PCBSD. I decided the next day that it wasn't worth the
time or effort to get it booting correctly. Lazily I reinstalled FreeBSD
and only installed the core package and setup nothing else, after all I
just needed the partition table. After the installation finished I
dropped into the live environment.

	newfs -U /dev/ada0p2
	mount /dev/ada0p2 /media
	mount /dev/da0 /mnt
	mount /dev/da1 /tmp
	cd /media
	restore -rf /mnt/root.dump

The interesting step there is mounting the second flashdrive under tmp.
One of the limitations I found with restore is it needs to be able to
write to /tmp before it can do a backup. As I was in a read only livecd
that posed a problem. The restore was done in a few short minutes. It
was weird when Firefox popped up asking if I would like to reopen my
tabs. Every thing worked a little too perfectly. We can't have that.

Up next – How not to upgrade to FreeBSD 9.2
