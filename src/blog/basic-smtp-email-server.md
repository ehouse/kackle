---
title: Basic SMTP Email Server
author: Ethan House
date: November 5, 2014
---

Running your own mail server can seem intimidating at first but once the
different layers are broken down it becomes much easier to tackle. There are
three main parts of a mail stack, the mta, mda, and mua. The Mail Transfer Agent
(MTA) is what handles the sending and receiving of emails. This is the smtp
server. The Mail Delivery Agent (MDA) handles delivery of emails to users, this
is usually over protocols like pop3 or imap. The final part is the Mail User
Agent (MUA), this is the client that lets the user send and receive mail.
Popular MUA's are Thunderbird and mutt.

Later on in the series I will go over more advanced features of the mail stack
like amavisd which is used for virus scanning and spamassassin which is for spam
prevention. I will also cover sieve, which is a cool client/server side
filtering language dovecot supports.

I will be going over how to setup the SMTP server in part 1. I have chosen
OpenSMTPD because it is feature filled and simple to setup. OpenSMTPD is OpenBSD
project that is designed to replace sendmail but in most cases can be used as a
replacement for postfix. Their primary goal of being simple and secure leads to
a rock solid application. They did an amazing job and it's actually difficult to
setup improperly.

### OpenSMTPD Setup

Make sure OpenSMTPD is installed on your system. It is available as packages for
most operating systems in the repositories. If it is not available you can build
from source.

The main file we are going to be working with is smtpd.conf. On FreeBSD it is
located at /usr/local/etc/mail/smtpd.conf. On CentOS it is
/etc/opensmtpd/smtpd.conf. Create it if it doesn't exist and move to the next
section.

#### smtpd.conf

This is the total smtpd config I have running at this point. I have broken down
each section and will describe it as I go.

    pki ehouse.io certificate "/etc/ssl/certs/mail.crt"
    pki ehouse.io key "/etc/ssl/private/mail.key"
    queue compression
    queue encryption key YourKeyHere

    listen on localhost
    listen on egress port smtp tls pki ehouse.io auth-optional
    listen on egress port submission tls-require pki ehouse.io auth

    table aliases db:/etc/mail/aliases.db

    accept from any for domain "ehouse.io" alias <aliases> deliver to maildir
    accept for any relay

#### SSL and Cert Signing

    pki mail.ehouse.io certificate "/etc/ssl/certs/mail.crt"
    pki mail.ehouse.io key "/etc/ssl/private/mail.key"
    queue compression
    queue encryption key YourKeyHere

This section sets up the cert and the private key used for SSL/TLS. I also
encrypt and compress the mail queue but both of these steps are optional.
OpenSMTPD orders it so mail is compressed before it is encrypted.

    openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/mail.crt -keyout /etc/ssl/private/mail.key

There are two options here. You can either self sign your own cert or have one
signed by a certificate authority. If you are just running a person mail server
I suggest self signed because it's quick and free. Run the command above to
generate the cert and the key used for the secure connection. We will be using
these later when we setup dovecot as well. Make sure the destination folders
actually exist otherwise it will error out. The line is rather long, so make
sure you grab all of it.
	
    openssl rand -hex 16

Finally to generate the queue encryption key run the command above and paste it
over the YourKeyHere text in the config. This step is optional but recommended.

#### Listen for connections

This sections is where things get hairy. It controls who and from where servers
or users can make connections and the configuration is pretty dense.

    listen on localhost
    listen on egress port smtp tls pki ehouse.io auth-optional
    listen on egress port submission tls-require pki ehouse.io auth
	
All incoming traffic to either port 25(smtp) or 587(submission) are passed
through. The smtp port is used for server to server and submission is used for
client to server email delivery. Due to how the standards were written smtp has
to start off cleartext and using startTLS move up to encrypted. Submission will
immediately and securely connect and authenticate. The pki is the key that we
designated earlier and called ehouse.io in this case.

#### Sending and Receiving Mail

And finally we are at the end of the config file. While these settings look a
bit terrifying I assure you they are perfectly safe.

    table aliases db:/etc/mail/aliases.db

    accept from any for domain "ehouse.io" alias <aliases> deliver to maildir
    accept for any relay


We are loading the alias file which, depending on the os, may be in a different
location. If you want to update this file without restarting smtpd you can run
`smtpctl update table aliases`. It is also worth noting you can have OpenSMTPD
use cleartext as well. I suggest sticking with binary because it can save on
lookup time if the files get large enough. Make sure you run `newaliases` and
`makemap`

The last two lines are pretty easy enough to follow. Accept mail from any source
going to `ehouse.io`. Authenticated system users are intrinsically allowed
through unless otherwise stated. I also want to accept mail for aliases and
virtual users that were setup earlier and deliver it to maildir. OpenSMTPD
supports quite a few delivery methods and I will go more into them in a later
article.

Which leaves us with the last line. This says to relay mail for any destination
from local authed users. There is also an implicit line to accept only from
local and relay it. This is what prevents it from being a open relay.

That's it for setting up a OpenSMTPD. Kinda scary how easy it was to setup.
Start OpenSMTPD and you should be able to send and receive mail on your local
account assuming you set a mx record. Creating MX records is easy enough so I
won't be going over it.

#### Next up

In the next section I will be going over the MDA which will be dovecot which
will allow you to use thunderbird. I will also cover amavisd and spamassassin to
deal with the inevitable spam you'll receive.
