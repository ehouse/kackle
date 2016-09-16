Title: The Complexities of Email
Date: 2016-08-22
Status: draft
Summary: A 1000ft view of email and how it works.

## How Sending Email works
Email itself is a complex set of protocols and servers running together to get
messages sent by users for other users. Almost anyone on the internet can
register a domain name and setup a corresponding email server.

### Logging in Via SMTP (Submission)
This is by far the most commonly used method of sending emails these days.
Whether you are using a client like outlook or a fancy pants website like gmail
this is what's happening. A connections is established cleartext (TLS) and
upgraded to SSL or a already cyphered conversation starts (SSL) saying basically
the same thing. I want to connect and do things. Try it yourself!

    [root@greygoose-centos7 ~]# telnet localhost 587
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    220 greygoose-centos7.csh.rit.edu ESMTP Postfix
    HELO mail.csh.rit.edu
    250 greygoose-centos7.csh.rit.edu
    QUIT
    221 2.0.0 Bye

Anymore then this and it becomes difficult as keys and auth credentials become
involved. Once we successfully login it's time to actually send email. To clear
up a common misconception I frequently hear, port 25 (smtp) is only used to
send email between servers. Since it is frequently blocked to limit spam sending
of owned machines port 587 (Submission) instead to send email to an email
server.

### Logging in Via Shell
When you log into a linux system a few special things happen regarding email, it
doesn't ask for a password. This is because you're always authed as seen as a
trusted user. This now how programs like mail and mutt work so well.

### Postfix (SMTP)
With email everything is sent as text which raises a huge challenge. This is
precisely why sending large files causes all kinds of issues. Everything is
base64 encoded and sent as a MIMETYPE most appropriate to it's context. It's
appended to the end of the email and sent as is.

    Content-Type: application/pdf;
    name="PVA and SEQ Plan.pdf";
    Content-Disposition: attachment;
    filename="PVA and SEQ Plan.pdf"
    Content-Transfer-Encoding: base64

    JVBERi0xLjUNCiW1tbW1DQoxIDAgb2JqDQo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFIvTGFu
    ...

This encoding doubles the size of the file it's trying to send and generally a
real headache to deal with. Once the email gets accepted by the smtp server is
when the processes gets interested. Most aspects of the spam/virus detection
processes have been offloaded to other programs conveyor belt style. The most
commonly used tool Amavisd so it's what I'll be talking about.

### Amavisd
This is where all of the magic happens with filtering. It's a glorified self
aware artificial intelligence sharing its time to filter email for us mortals.
Once avamisd has checked the email passes all of the requirements to actually be
sent (valid addresses, valid headers, etc...) it heads over to be scanned. Once
scanned by clamav against a host of bad file signatures the email gets tagged
and passed over to spamassassin. Spamassassin runs all kinds of language
processes (glorified regex's and encoding checks) and assigns a spam score. If
it is above a certain value it's either tagged as spam, given a spam header
(\*\*\*SPAM\*\*\*) or discarded all together. Once we're sure it's not a virus
or spam we sign it with a key that's verified to be from us and it's sent on
its way to the big scary world of mail relays.

That's it, how sending email works on a pretty standard email server.

## Receiving Email
Receiving emails operates the exact same way except that instead of the user
connecting to the email server it's another email server attempting to connect.
If the email server passes appropriate checks then the emails are delivered into
the mailbox's of the users listed as destinations. Due to the open nature of
this exchange it is difficult to peg spam emails as spam unless they're known
spammers. You're only tool assuming the sending IP is not on a blacklist is
language processing and user metrics. Once an email is verified as wholesome it
is placed in a maildir on the users account until the user retrieves it through
Dovecot.

### Dovecot (IMAP and POP3)
This service is what manages remote connections from clients like Thunderbird or
rainloop. Once connected the user has the options to retrieve their mail, delete
mail already stored or manage the meta data of the email itself. All of these
changes are synced with the server so all clients will reflect them.
