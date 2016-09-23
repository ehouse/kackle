---
title: mu4e as a Email Client
author: Ethan House
date: July 3, 2015
summary: A breakdown and config of my mu4e config I've been using recently. It's backed with emacs and uses mu as a powerful filtering language.
---

A coworker told me about this awesome life changing mail client called mu4e so
of course I had to try it. Mu is an incredibly powerful mail indexer built on
top of xapian. It can index and search through 20,000+ emails in fractions of a
second. Its searching language is easy to use and incredibly powerful. From the
distance I loved everything that mu4e was and could do.

I ended up sticking with Thunderbird for my personal email however. My issue
with it is that it was too life changing. Too much lift for just an improved
email experience. My biggest issue was its lack of imap support. Why, might you
ask, does a mail client not support imap. The answer is they chose not to.
Instead they read from a Maildir which you need to create yourself with
offlineimap or a similar tool. Polling is not a supported feature so you need a
cronjob to run every few minutes. Not great if you are having a minute by minute
discussion or aren't checking your email every few minutes. Not to mention the
need to sync not just the headers but the full email body because you can't
lazily download them as you read emails. The results of this is that it can take
HOURS for the initial sync to finish.

My second gripe is that it is of course entirely emacs based. I'm too ingrained
with modal text editing to change for just my email client. Most machines I work
on don't even come with emacs installed and changing that might get me a stern
talking to. There is a way to tie it into mutt but it doesn't look to be nearly
as mature as mu4e. 

My final thoughts are that mu4e is amazing if you are willing to learn emacs.
It's well worth it for the power you get back. I didn't realize how awful email
search was until I got familiar with mu. Too intrusive for me however.

### My mu4e config

```lisp
(require 'mu4e)
(require 'smtpmail)

; System Settings
(setq message-send-mail-function 'smtpmail-send-it)
(setq mu4e-get-mail-command "offlineimap")
(setq mu4e-update-interval (* 10 60))
(setq user-full-name "Ethan House")
(setq mu4e-compose-signature "Ethan House")

(setq mail-user-agent `mu4e-user-agent)
(setq message-kill-buffer-on-exit t)

; Bawls Mail
(setq smtpmail-starttls-credentials
      '(("mail.ehouse.io" 587 nil nil))
      user-mail-address "ehouse@ehouse.io"
      smtpmail-smtp-server "mail.ehouse.io"
      smtpmail-local-domain "ehouse.io"
      smtpmail-smtp-service 587)

; Bawls Mail
(setq mu4e-maildir     "~/Maildir"         ;; top-level Maildir
    mu4e-sent-folder   "/bawls/Sent"       ;; folder for sent messages
    mu4e-drafts-folder "/bawls/Drafts"     ;; unfinished messages
    mu4e-trash-folder  "/bawls/Trash"      ;; trashed messages
    mu4e-refile-folder "/bawls/Archive")   ;; saved messages

; Render html in w3m. Requires w3m be installed.
(setq mu4e-html2text-command "w3m -T text/html")

; Default IMAP behavior
(setq mu4e-sent-message-behavior 'delete)

; Disable threading and don't ask to quit.
(setq mu4e-headers-show-threads nil)
(setq mu4e-confirm-quit nil)
```
