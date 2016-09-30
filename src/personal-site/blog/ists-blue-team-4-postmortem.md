---
title: ISTS 2016 Blue Team 4 Postmortem
author: Ethan House
date: March 27, 2016
summary: My thoughts on RIT's 2016 ISTS competition.
---

This past weekend I participated in a hacking competition Information Security
Talent Search at RIT as a defending team. The goal was to attack other teams
machines while keeping yours online.  While this is going on there are bonuses
or injects being handed out that get’s you bonus points for completing various
challenges. An example of an inject was to run and connect to a minecraft server
on some other teams servers.

Unfortunately we didn’t win but our team did win the title of best defense which
I hold as high as winning. My team knew going in that our hacking and offensive
skills were lacking compared to the other teams but we gave it our all.

## Our Strategy

### PURGE EVERYTHING

This turned out to be the winning strategy in the long run in terms of keeping
us running. If we saw something that seemed out of place or was not needed we
tar’ed it up and plopped it in /root for safe keeping. All services were
stripped to their bare essentials and left in what I would call a barely working
state but was just enough to fulfill the score board checks. This included
disabling ssh and sudo which removed most of the attack vectors on the machines.
Dirty but REALLY effective. 

### Firewalls

Many of the attacks or Injects involved opening processes on ports and running
commands through them. The direct counter to this of course is to lock the whole
system down to only the ports it needs. It’s impossible to open a million netcat
processes on every port if binding is blocked. The email server only needed pop3
and smtp so everything was blocked except for port 25 and 110.

### Condense and Minimize

Stick to what you need in the long run. We did not have the control we liked on
our cloud infrastructure so we moved as much as we could to our local esxi
server. Our build server ran a alpine Linux instance with ssh and our AD server
was just DNS. The scoring engine only cared that they were available, not that
they were usable. We actually had people on red and white team complain to us at
how difficult it was to get at these boxes and that feels like a victory to me.

### Commands that Helped

- `w` - Shows who’s logged in.
- `ss` OR `netstat -alutpn` OR `sockstat -4` - Shows active network connections to
the outside world.
- `routes` - Used to display current routes the system is using. Once or twice I
found a route to another team.

### Files and Configs to Watch

There were quiet a few files that had absolutely no reason to be changing through
the competition so we either made them non-writeable to watched them like a
hawk.

- `.bashrc` AND `.vimrc` - quite a few teams hid commands in these files that
would run when a user did something. Very nasty. Ensure these are simple and
fully understood especially on the root user.
- `my.cnf` OR `postgresql.conf` - Only allow connections from IP's you trust.
Double check your account privileges as well, there is zero reason an admin
account should ever connect over the network. Restricting account access won't
stop a SQL injection but it will save your machine and your other databases. 

### Pitfalls to Avoid

Our HTTP server had to host a buggy and security nightmare php app which also
ran our banking terminal. For the first half of the competition I just hosted
the default apache page which was enough to score. The problem arose when we
actually had to use the banking app to pay our power bill to keep our servers
running. The red team had XSS’ed it through a specially crafted tweet that would
drain your balance every time you access the page. I mistakenly ignored large
aspects of the banking aspects of the game as well as the app. I should have
gone through it at the beginning and removed the XSS vectors.

## What We Loved

I thought the infrastructure of the competition was well put together. Rarely
were there any obvious lag or hiccups with with the VM's or networking. The only
issues we had with hardware was when our VM server had a hard drive failure
which was hardly the fault of anyone running the competition. 

## What We Want Changed Next Year

As I mentioned the game had a concept of money which was awarded by completing
challenges. My issues come from what it can be spent on, specifically three of
them. Restore a system to it’s original snapshot, Power Off and Console Access.
All of our VM’s were shutdown with zero way for us to turn it back on for about
an hour. We had ALL of our VM’s reset THREE times. FINALLY, a team payed to have
console access to our VM’s where they turned them off and booted into single
user mode.

There was no way to block this, no way to defend against this and once it’s been
paid for no one to mitigate. Three times I had to rebuild our VM’s as if we were
at the beginning of the competition all while every team destroyed our VM’s with
the known vulnerabilities. By the time we got half of the VM’s in a safe state
the other half are owned beyond repair and had to be reset. We ended up draining
our entire bank account just getting machines turned back on or reset to remove
the forced backdoors. This is precisely why we moved all of our services we
could to the local ESXI cluster as we couldn’t trust the cloud infrastructure.
Due to routing issues we were only able to put half of the VM’s we needed to
host behind the local ESXI and we continue to fight off resets and bought
backdoors for the entire competition. Frustrating for us and embarrassing for
the other teams that had to buy their through our servers defenses.
