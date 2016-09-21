---
title: Linux References
---
<div class='article-list'>

Common actions for RHEL based distros.

## Journalctl
- `journal --since 9:00 --until 12:00`  
Shows system logs between those times

- `journal -u postfix --since yesterday -f`  
Shows all postfix logs since yesterday and follows logs

- `journal -k -n 20`  
Kernal messags since last boot limiting to 20 messages

## Selinux
All of the steps required to establish, create and deploy a selinux module.

- `cat /var/log/audit/audit.log | audit2why`  
Explains every AVC report.  
Requires _policycoreutils_

- `audit2allow -a -w`  
Easier to type version of the above command.  
Requires _policycoreutils_

- `audit2allow -a`  
Generates readable selinux policy from audit/audit.log and prints it to the
terminal.  
Requires _policycoreutils_

### Generating Generic Modules #####
- `audit2allow -a -M POLICYNAME`  
Generates selinux policy from audit/audit.log POLICYNAME. Policy must be loaded
in manually.  
Requires _policycoreutils_

- `semodule -i POLICYNAME.pp`  
Load policy POLICYNAME manually.  
Requires _policycoreutils_

### Generate Custome Module
- `audit2allow -a -m POLICYNAME`  
Generates uncompiled selinux policy from audit/audit.log named POLICYNAME and
file POLICYNAME.te is created. This file may be edited by hand for better
debugging. Files must be compiled before it can be loaded in as a module.  
Requires _policycoreutils_

- `checkmodule -M -m -o POLICYNAME.mod POLICYNAME.te`  
Generate mod from from POLICYNAME.te file. Think of this as a C object files.  
Requires _policycoreutils_

- `semodule_package -m POLICYNAME.mod -o POLICYNAME.pp`  
Generates a compiled selinux module from a .mod file. It is reccomended to keep
the .tt file around as it is difficult to reverse engineer what a .pp file does
once compiled.  
Requires _policycoreutils_

### Searching
- `ausearch -m avc -ts recent`  
Get recent (10 minutes) of AVC messages.  
Requires _audit_

- `seleart -a /var/log/audit/audit.log`  
Generates a report of AVC messages and why they are happening.  
Requires _setroubleshoot-server_

</div>
