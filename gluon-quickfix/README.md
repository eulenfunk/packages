# gluon-quickfix

This package will add a cronjob that fixes some problems that rarely occur, but are easy to work around. 

### Safety checks:
To be sure, that the script is not disturbing the start and update process:
- if autoupdater is running, `exit`
- if the router started less than 5 minutes ago, `exit`

### Workarounds
- check if we have lost any neighbours, `iw dev $DEV scan`
- if respondd or dropbear not running, reboot (probably ram was full, so more services might've crashed)
- reboot if there was a kernel (batman) error
