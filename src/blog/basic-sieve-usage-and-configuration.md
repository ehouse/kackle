---
title: Basic Sieve Usage and Configuration
author: Ethan House
date: June 22, 2015
summary: A quick guide to setting up and using sieve for Dovecot 2.x email servers. 
---

### Setting up Sieve Access

Sieve is a server side protocol for filtering mail. The benefit over sorting
mail client side is that rules will be applied regardless of your MUA. Sieve
scripts can be edited locally or remotely using the managesieve service. I am
using the Pigeonhole implementation of sieve which is bundled with dovecot 2.x.
I will be going over in a later article how to setup dovecot.

#### Testing locally

To test that everything is working correctly create a `.sieve/` folder in your
home directory and create your sieve scripts within it. Call it anything you'd
like but it has to end in a `.sieve` extension. I suggest you copy my basic
config that I have listed below and make the appropriate changes.

When you are all done editing create a symlink in your home directory pointing
to the file you just made and call it `.sieve.conf`. This will be your active
sieve script that Pigeonhole uses.

Send an email that would test your script. If there are any issues with the
script you wrote it be logged to `~/.sieve.conf.log`.

#### Accessing remotely with Thunderbird 

As of writing this article the sieve plugin for Thunderbird available for
download through the built in store does not work. It broke during an API change
and a new version has not been submitted. Instead a nightly release has to be
downloaded from the projects [Github page](https://github.com/thsmi/sieve). You
can find the nightly version I used
[here](https://github.com/thsmi/sieve/blob/master/nightly/0.2.3/sieve-0.2.3g.xpi).

Install the xpi file and you should be able to connect to your sieve server.
Issues can be worked through with the builtin debugger.

When you get access either open your existing rule set or create a new one.
Thunderbird will run though it and make sure there are no syntax errors. Make
sure you activate the script which will create the symlink for you if you
haven't already. The plugin also has some good resources of sieve script
writing.

### Basic Sieve Usage

The important notes about the config listed below are that the special commands
like fileinto and addflag need to be included with require if they are used. The
other thing to note is that the stop command is required unless you want
multiple actions applies to a single envelope.

#### Basic Sieve Config

    require ["fileinto", "imap4flags"]; 

    # This rule is for spamassassin headers. 
    if header :contains "X-Spam-Flag" "YES" {
    fileinto "Spam";
    stop;
    }

    # Apply the Personal label to emails addressed to me. Continue executing the script. 
    if address :is ["to","cc"] "ehouse@ehouse.io"{
    addflag "label3";	
    }

    # File openbsd misc mailing list into openbsd/misc folder.
    if address :is ["to","cc"] ["misc@openbsd.org","misc@cvs.openbsd.org"]{
    fileinto "openbsd.misc";
    stop;
    }

    # File into folder oss-security.
    if address :is ["to","cc"] "oss-security@lists.openwall.com"{
    fileinto "oss-security";
    stop;
    }

    # File system logs into logs folder.
    if address :is "from" "root@ehouse.io"{
    fileinto "logs";
    stop;
    }

### Additional sieve resources

You can check out [here](http://wiki2.dovecot.org/Pigeonhole/Sieve) for a full
list of options for sieve or
[here](http://wiki2.dovecot.org/Pigeonhole/Sieve/Examples) for some great sieve
examples. It's a little weird at first but in no time you'll be writing new
filters rules without looking at the docs.
