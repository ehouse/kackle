---
title: Linux References
---
Common actions for RHEL based distros.

## Journalctl
- 
`journal --since 9:00 --until 12:00`
   : Shows system logs between those times

- 
`journal -u postfix --since yesterday -f`
   : Shows all postfix logs since yesterday and follows logs

- 
`journal -k -n 20`
   : Kernal messags since last boot limiting to 20 messages

## Selinux
- 
`cat /var/log/audit/audit.log | audit2why` 
   : Explains every AVC report.
   : Requires _policycoreutils_

- 
`audit2allow -a -w`
   : Same as above
   : Requires _policycoreutils_

- 
`audit2allow -a`
   : Generates readable selinux policy from audit/audit.log
   : Requires _policycoreutils_

### Generating Generic Modules #####
- 
`audit2allow -a -M POLICYNAME`
   : Generates selinux policy from audit/audit.log POLICYNAME
   : Requires _policycoreutils_

- 
`semodule -i POLICYNAME.pp`
   : load policy POLICYNAME
   : Requires _policycoreutils_

### Generate Custome Module
- 
`audit2allow -a -m POLICYNAME`
   : Generates uncompiled selinux policy from audit/audit.log named POLICYNAME and create POLICYNAME.te
   : Requires _policycoreutils_

- 
`checkmodule -M -m -o POLICYNAME.mod POLICYNAME.te`
   : Generate mod from from POLICYNAME.te
   : Requires _policycoreutils_

- 
`semodule_package -m POLICYNAME.mod -o POLICYNAME.pp`
   : Compile mod file to POLICYNAME.pp
   : Requires _policycoreutils_

### Searching
- 
`ausearch -m avc -ts recent`
   : Get recent (10 minutes) of AVC messages
   : Requires _audit_

- 
`seleart -a /var/log/audit/audit.log`
   : Generates a report of AVC messages and why they are happening
   : Requires _setroubleshoot-server_
