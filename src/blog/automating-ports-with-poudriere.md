---
title: Automating Ports with Poudriere
author: Ethan House
date: September 9, 2014
summary: Automating the building of FreeBSD Ports in jails. A fun weekend project I setup on a few servers.
---

While pkg-ng is good for simple FreeBSD setups it rarely fits all of my needs. Eventually you'll need a package with
custom build flags. While ports is pretty decent in itself it is a royal pain to automate. New to FreeBSD 10, poudriere
allows ports to be built in the background with no human interaction post setup. Setup is quick and easy to maintain.

### Setup
I recommend copying over the sample conf file and making changes as you see fit. Make sure to read it over as it will
not work out of the box.

``` bash
cp /usr/local/etc/poudriere.conf.sample /usr/local/etc/poudriere.conf
```

I have also included my config for reference. This should work assuming you have the files and folders in the proper
places and create a SSL key for packaging signing. Check out the signing section below.

``` bash
ZPOOL=zroot

FREEBSD_HOST=ftp://ftp.freebsd.org
RESOLV_CONF=/etc/resolv.conf
BASEFS=/usr/local/poudriere
USE_PORTLINT=no
USE_TMPFS=yes
DISTFILES_CACHE=/usr/ports/distfiles
CHECK_CHANGED_OPTIONS=verbose
CHECK_CHANGED_DEPS=yes

PKG_REPO_SIGNING_KEY=/etc/ssl/private/pkg.key
CCACHE_DIR=/var/cache/ccache
```

### First Run
Run these commands to setup the poudriere environment. I included comments on what each line does. This will create the
ports tree and setup the jail template.

``` bash
# Create copy of the ports tree
poudriere ports -c
# Create base jail
poudriere jail -c -j 10x64 -v 10.0-RELEASE -a amd64
# Create port list file for poudrier to build from
portmaster --list-origins | sort -d > /usr/local/etc/poudriere-list
```

You can have poudriere build packages with special options. These options will persist across builds.

``` bash
poudriere options -c www/firefox
```

### Package Signing
Even if your repo is private, signing packages is a good thing to do. Assuming you keep your private key private you can
be sure the packages were built on your system. Distribute the cert however you see fit but make sure anyone using your
repo has access to it.

``` bash
mkdir -p /usr/local/etc/ssl/keys /usr/local/etc/ssl/certs
chmod 600 /usr/local/etc/ssl/keys
openssl genrsa -out /usr/local/etc/ssl/keys/pkg.key 4096
openssl rsa -in /usr/local/etc/ssl/keys/pkg.key -pubout > /usr/local/etc/ssl/certs/pkg.cert
```

### Final Setup
You're almost done. All you have left to do is actually host the content somewhere. Just point your trusty webserver at
the package set and you're ready to go.

``` bash
server {
    listen       80;
    server_name  pkg.ehouse.io;

    location / {
        autoindex on;
        root /usr/local/poudriere/data/packages/10amd64-default/;
    }
}
```

Now you need to create the repo for FreeBSD to read from. Create the file /usr/local/etc/pkg/repos/poudriere.conf for
pkg to read from. The contents of the repo file are below. Adjust the url to work for your system.

``` bash
poudriere: {
  url: "http://pkg.ehouse.io",
  mirror_type: "http",
  signature_type: "pubkey",
  pubkey: "/usr/local/etc/ssl/certs/pkg.cert",
  enabled: yes
}
```

Time to automate. I wrote up a series of cronjobs to handle the processes of automating. Tweak to how you see fit.

``` bash
@weekly     /usr/local/bin/poudriere ports -u; /usr/local/bin/poudriere bulk -f /usr/local/etc/poudriere-list -j 10x64
0 6 * * *     /usr/sbin/pkg update
0 23 * * *     /usr/local/sbin/portmaster --list-origins | sort -d > /usr/local/etc/poudriere-list
```

### Web Frontend
Poudriere includes a neat little web frontend to watch packages as they are built. Example
[Here](http://pkgstats.ehouse.io/). I included the nginx config I wrote. Change the root to point at what ever you
named the jail template.

``` bash
server {
    listen       80;
    server_name  pkgstats.ehouse.io;

    location / {
        root /usr/local/poudriere/data/logs/bulk/10x64-default/latest;
        index index.html;
        autoindex on;
    }
}
```
There you go. A fully functional automated ports building process. Probably took no more then 30 minutes.


I used [BSDNow](http://www.bsdnow.tv/tutorials/poudriere) for reference when writing this. Check out their stuff, it's
pretty great.
