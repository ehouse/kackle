---
title: Advanced PF Usage
date: June 20, 2014
author: Ethan House
summary: PF is as powerful as iptables in a lot of regards. I'm going to beak down many of the additions I've made since I last posted about PF. This is more or less just a breakdown of my current running pf config.
---

Since my last PF post I've made some changes to my pf.conf file. I've broken the
config into its own separate section and displayed them below with some
explanation. All together the config is organized and easy to maintain, which is
always good.

### Macros

Macros can be thought of as variables. They can store either a single scalar value
or an arrays of values separated by a comma and surrounded by curly braces. All
scalars must be in quotes.

    # TCP services to allow, either names from /etc/services or port numbers
    tcp_services = "{http, https, ssh, 25565, 8123, 8080, 8000, 12345}"
    # UDP Services to allow, either names from /etc/services or port numbers
    udp_services = "{domain, 60000:60010}"

    # Macro of the primary interface
    ext_if="bce1"
    jail_if="lo1"

Pretty much the same as before, except now I have a section for mosh. I use PF's
colon operator to give me a range of ports, 60000 through 60010.

### Tables

Tables are similar to macro groups except they can be edited without restarting
PF. Great for blacklists or whitelists. Tables can only store Ip addresses though,
limiting there use.

    table <whitelist> { 11.22.33.44, 123.45.67.89 }

I've created a whitelist that will be quickly passed though, preventing other rules
from being applied. Good for the accidental screw up. I don't have a blacklist
table because I use denyhosts.  

    pfctl -t whitelist -T add 192.168.0.0/16

Cidr notation is also accepted in tables.

### Traffic Normalization

Scrub guarantees that all traffic passed into the filter section is not fragmented. Packets
that are fragmented are put into a buffer to wait until the rest of the packet arrives.

	# Scrubs packets for possible issues. All Trafic is reassembled. Might cause
	# issues for games and NFS
	scrub in on $ext_if all fragment reassemble

Be cautious with scrub rules. They can cause issues with games and NFS traffic.
To log a rules effect add "log" after the in or out keyword as such.

    scrub in log on $ext_if all fragment reassemble

### Filtering

Not much crazy has changed here. I've added two new rules to allow icmp trafic and to
quick pass from the whitelist table. I've also added a rule which drops all
trafic with a destination address of 255.255.255.255. It's commented it out though,
most of the broadcast traffic I was getting was from UPnP. Not allowing
UPnP(udp 1900, tcp 5000) is easier.

	# Block all traffic by default
	block all

	# Ignore local,internal traffic
	set skip on lo0

	# Quick antispoof check for primary interface
	antispoof log quick for $ext_if

	# Quick drop on broadcast traffic
	#block in quick on $ext_if from any to 255.255.255.255

	# Allow incoming and outgoing ICMP
	pass inet proto icmp from any to any

	# Allow in traffic from services macro
	pass in quick from <whitelist> flags S/SA synproxy state
	pass in on $ext_if proto tcp to any port $tcp_services
	pass in on $ext_if proto udp to any port $udp_services

	# Allow ALL outbound traffic
	pass out on $ext_if proto tcp from any to any keep state
	pass out on $ext_if proto udp from any to any keep state

##Other Usefull Commands.
Lots of commands are available to do just about everything under the sun with pf.
I've listed below some of the more useful commands I've found.

```bash
# Realtime logging from pglog0 device
tcpdump -n -e -ttt -i pflog0
# realtime logging from pf log file
tcpdump -n -e -ttt -r /var/log/pflog

# parse ruleset for errors, does not load
pfctl -vnf /etc/pf.conf
# maintain state and reload config
pfctl -f /etc/pf.conf
# same thing as above, just easier to remember
service pf reload

# List loaded rules
pfctl -sr
# View state table
pfctl -ss
# List everything
pfctl -sa
```
