# gluon-quickfix

This package will add a cronjob that fixes some problems that rarely occur, but are easy to work around. 
(this branch "v2016.2.x" is the one used to build against gluon "v2016.2.x" by ffdus)

the condition are checked every 7 minutes:

### Safety checks:

To be sure, that the script is not disturbing the start and update process:
- if autoupdater is running, `exit`
- if the router started less than 10 minutes ago, `exit`
- if the router is up less than 1 hour: do not actually do something, just write to syslog what would happen.

### Workarounds

what is checked:

- if autoupdater is started but no proggressing for more than 1 hour: hard reboot
- check if we have lost any neighbours, `iw dev $DEV scan` in lowpri mode.
- if respondd or dropbear not running, reboot (probably ram was full, so more services might've crashed)
- reboot if there was a kernel (batman) error
- reboot if there are ath/ksoftirq-malloc-errors (upcoming oom scenario)
- if wifi is configured and not disabled: do 'iw dev'. If this does not return (process hangs) or delivers no result: reboot
- if autoupdater is running for more than an hour and no progress visible: reboot.
- if more than 8 tunneldigger-threads running: reboot. System is definitly clogged up and reboot is the fastest and most reliable way out of this rare (but load-effective) scenario. 
- in case the br-client has no ipv6 out of the prefix declared by the site.conf: This is some timing related netif-probroblem which may occurr during boot time with "lan_mesh" and/or "wan_mesh" activated but no port with eth-link. by consequence the node will probably not be visible for respondd-request (map), web and ssh on the expected ipv6. 

