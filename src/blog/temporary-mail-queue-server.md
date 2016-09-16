---
title: Temporary Mail Queue Server
author: Ethan House
date: June 21, 2015
---

I needed to stand up a temporary queue server to store mail while our primary
file server was out of commission. This was the config I created to do just
that. I went with OpenSMTPD because it was by far the easiest choice when
standing up a new SMTP server. I had the whole thing running in less then an
hour.

``` bash
pki csh certificate "/etc/ssl/certs/csh_star.crt"
pki csh key "/etc/ssl/private/csh_star.key"

listen on localhost
listen on egress port smtp tls pki csh

table aliases file:/etc/mail/aliases

bounce-warn 7d
expire 30d

accept from any for domain "csh.rit.edu" alias <aliases> relay "mail.csh.rit.edu"
```

The server will hold the mail until it can be delivered. Users won't be able to
send but at least mail won't be lost. The final step is to setup the second
backup MX record for this mail host and turn everything on. Watch the mail queue
to make sure mail is being relayed.

Due to the lack of physical access and being students it's hard to prevent
issues like this. It's a bad solution to a worse problem but it solved our
looming problem of losing mail.
