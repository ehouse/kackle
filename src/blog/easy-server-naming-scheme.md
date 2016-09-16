---
title: Easy Server Naming Scheme
author: Ethan House
date: March 3, 2016
---

Coming up with names for servers or VM's can be pretty difficult. Often times
names become obsolete or don't describe the server in a way that's meaningful.
The best system is one where every machine has a unique name as it's A record
and all of the service specific names become CNames. This allows the server to
host many services without causing naming confusion or obsolete hostnames if a
primary service is changed.

The article written by
[mnx.io](http://mnx.io/blog/a-proper-server-naming-scheme/) describes in great
detail how to pull this off. I've found it works best in smallish environments
of less then 100 servers. I've helped implement this scheme in two places and it
worked out great both times. I would heavily recommend it whenever possible.

### Unique Names

I've set up a server endpoint that will retrieve a list of unique names from
[here](https://web.archive.org/web/20090918202746/http://tothink.com/mnemonic/wordlist.html).
The pool of words comes from Oren Tirosh's mnemonic encoding project. The order
of the names will be random so it's up to you to verify the names aren't already
in use for your environment. You can can randomly generate list of hostnames at
[hosts.ehouse.io](https://hosts.ehouse.io).
