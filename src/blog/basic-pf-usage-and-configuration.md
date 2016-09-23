---
title: Basic PF Configuration
author: Ethan House
date: February 2, 2013
summary: FreeBSD PF and config examples. Quick and useful commands with explanations for what they do.
---

After a brief mishap with partition tables and ZFS and FreeBSD are finally setup
on my personal server. I needed something to act as a firewall and went with PF.
I decided to base my setup off of security groups for Amazon EC2. All outbound
traffic is allowed but inbound traffic must pass through a whitelist of
services. To add another service just add the port name or the port number to
the tcp_services list.

This was what I came up with.

	### MACROS
	# TCP services to allow, either names from /etc/services or port numbers
	tcp_services = "{http, https, ssh, rpc, domain}"

	# UDP Services to allow, either names from /etc/services or port numbers
	udp_services = "{domain}"

	# Macro of the primary interface
	ext_if="bce1"

	### Packet Filtering
	# Block all traffic by default
	block all

	# Ignore lo0 interface for filtering
	set skip on lo0

	# Allow IN traffic from white listed service macro
	pass in on $ext_if proto tcp to any port $tcp_services
	pass in on $ext_if proto udp to any port $udp_services

	# Allow ALL outbound traffic
	pass out on $ext_if proto tcp from any to any keep state
	pass out on $ext_if proto udp from any to any keep state

To setup PF copy this config to `/etc/pf.conf`.

Run the command `pfctl -ef /etc/pf.conf` to enable pf and load the comfig.

The command `pfctl -d /etc/pf.conf` can be used to disable pf while debugging.

Misc Commands:

	pfctl -sr  # view loaded config
	pfctl -ss  # view established connections
	pfctl -vnf # parse ruleset for errors without loading it in
