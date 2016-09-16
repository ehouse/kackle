---
title: Why I use Cloudflare
author: Ethan House
date: September 19, 2013
---

A [friend](http://worrbase.com/) of mine recently showed me a service called
[CloudFlare](https://www.cloudflare.com/index.html) and I'm surprised it's not
more commonly used than it is. It is especially good for small sites driven by a
single server. They offer services like website caching and auto minification of
CSS and JavaScript. These are all great features for a sysadmin who doesn't
necessarily want to spend his entire day writing CSS and JavaScript.

CloudFlare's line of security features are also impressive. They do analysis of
traffic heading too and from the server watching for malicious activity like XSS
and SQL injections. When CloudFlare detects users doing this over and over they
get blocked from all CloudFlare enabled sites. Rules can also be written to
restrict content on a user level or even country level.

My favorite part probably because I am a networking geek is the use of
[anycast](http://en.wikipedia.org/wiki/Anycast) to route traffic. So even though
my server is in Rochester I get good latency because it is mirrored in San Jose.
This is normally a feature only available to companies with dozens of data
centers spread across the country.

These are some pretty impressive features for a free service. I would recommend
this to just about every webmaster out there.
